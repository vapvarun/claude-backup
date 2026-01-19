#!/bin/bash
# =============================================================================
# Claude Code Memory Automation Setup
# Run this on any Mac to set up automatic session memory capture
# Usage: bash setup-memory-automation.sh
# =============================================================================

set -e

echo "Setting up Claude Code Memory Automation..."

# Create directories
mkdir -p ~/.claude/hooks
mkdir -p ~/.claude/scripts
mkdir -p ~/.claude/logs

# -----------------------------------------------------------------------------
# 1. Create the session memory hook (shell script)
# -----------------------------------------------------------------------------
cat > ~/.claude/hooks/session-memory.sh << 'HOOKEOF'
#!/bin/bash

# Claude Session Memory Capture Hook
# Captures significant session milestones (commits, code changes)

MEMORY_PROCESSOR="$HOME/.claude/scripts/process-session-memory.py"
LOG_FILE="$HOME/.claude/logs/session-memory.log"

mkdir -p "$(dirname "$LOG_FILE")"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_message "Session memory hook triggered"

CURRENT_DIR=$(pwd)
PROJECT_NAME=$(basename "$CURRENT_DIR")
GIT_BRANCH=""
GIT_REPO=""

if git rev-parse --git-dir > /dev/null 2>&1; then
    GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    GIT_REPO=$(git remote get-url origin 2>/dev/null | sed 's/.*[:/]\([^/]*\/[^/]*\)\.git$/\1/' || echo "local")
    log_message "Git context: repo=$GIT_REPO, branch=$GIT_BRANCH"
fi

# Calculate session duration
SESSION_DURATION=0
if [ -f /tmp/claude_session_start.txt ]; then
    START_TIME=$(cat /tmp/claude_session_start.txt)
    NOW=$(date +%s)
    SESSION_DURATION=$((NOW - START_TIME))
    log_message "Session duration: ${SESSION_DURATION} seconds"
fi

SESSION_DATA=$(cat <<EOF
{
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "project_name": "$PROJECT_NAME",
    "working_directory": "$CURRENT_DIR",
    "git_branch": "$GIT_BRANCH",
    "git_repo": "$GIT_REPO",
    "hook_type": "${CLAUDE_HOOK_TYPE:-session_end}",
    "session_id": "${CLAUDE_SESSION_ID:-unknown}",
    "session_duration": $SESSION_DURATION
}
EOF
)

RECENT_COMMITS=""
if [ -n "$GIT_BRANCH" ]; then
    RECENT_COMMITS=$(git log --since="1 hour ago" --pretty=format:"%h|%s|%an|%ad" --date=relative 2>/dev/null || echo "")
fi

FILE_CHANGES=""
if [ -n "$GIT_BRANCH" ]; then
    FILE_CHANGES=$(git status --porcelain 2>/dev/null || echo "")
    DIFF_STATS=$(git diff --stat 2>/dev/null || echo "")
    STAGED_STATS=$(git diff --cached --stat 2>/dev/null || echo "")
fi

FULL_CONTEXT=$(python3 -c "
import json
session_data = $SESSION_DATA
recent_commits = '''$RECENT_COMMITS'''
file_changes = '''$FILE_CHANGES'''
diff_stats = '''$DIFF_STATS'''
staged_stats = '''$STAGED_STATS'''

context = {
    'session_data': session_data,
    'recent_commits': recent_commits,
    'file_changes': file_changes,
    'diff_stats': diff_stats,
    'staged_stats': staged_stats,
    'environment': {
        'user': '$USER',
        'hostname': '$(hostname)',
        'platform': '$(uname -s)'
    }
}
print(json.dumps(context, indent=2))
" 2>/dev/null || echo '{}')

TEMP_FILE="/tmp/claude_session_$(date +%s).json"
echo "$FULL_CONTEXT" > "$TEMP_FILE"

if [ -f "$MEMORY_PROCESSOR" ]; then
    (
        python3 "$MEMORY_PROCESSOR" "$TEMP_FILE" >> "$LOG_FILE" 2>&1
        rm -f "$TEMP_FILE"
    ) &
    log_message "Memory processor started in background"
else
    log_message "Memory processor not found"
    rm -f "$TEMP_FILE"
fi

exit 0
HOOKEOF

chmod +x ~/.claude/hooks/session-memory.sh
echo "Created: ~/.claude/hooks/session-memory.sh"

# -----------------------------------------------------------------------------
# 2. Create the Python processor
# -----------------------------------------------------------------------------
cat > ~/.claude/scripts/process-session-memory.py << 'PYEOF'
#!/usr/bin/env python3
"""
Session Memory Processor - Stores significant coding sessions only
Requires: git commits or code changes to store (no research/chat sessions)
"""

import json
import sys
import os
import re
import hashlib
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Tuple

class SessionMemoryProcessor:
    def __init__(self):
        self.significance_threshold = 5  # Require real work (duration + activity)
        self.filters = {
            "trivial_patterns": [
                r"\.DS_Store", r"__pycache__", r"node_modules", r"\.git/",
                r"\.venv/", r"venv/", r"\.pyc$", r"dist/", r"build/",
                r"\.next/", r"\.nuxt/", r"coverage/", r"\.cache/",
                r"\.lock$", r"-lock\.json$", r"\.log$", r"\.min\.", r"\.map$",
            ],
            "significant_patterns": [
                r"feat[:\(]", r"fix[:\(]", r"BREAKING", r"performance",
                r"security", r"refactor", r"test[:\(]",
            ],
            "file_weight": {
                ".py": 2.0, ".js": 2.0, ".ts": 2.0, ".jsx": 2.0, ".tsx": 2.0,
                ".php": 2.0, ".go": 2.0, ".rs": 2.0, ".java": 2.0,
                ".sh": 1.5, ".yml": 1.5, ".yaml": 1.5, ".json": 1.3, ".md": 1.2,
            },
            "minimum_changes": 3,
            "minimum_lines": 10,
        }

    def calculate_significance(self, session_data: Dict[str, Any]) -> Tuple[float, List[str]]:
        score = 0
        reasons = []

        file_changes = session_data.get('file_changes', '')
        recent_commits = session_data.get('recent_commits', '')
        diff_stats = session_data.get('diff_stats', '')
        staged_stats = session_data.get('staged_stats', '')

        # Duration bonus (not enough alone)
        session_info = session_data.get('session_data', {})
        session_duration = session_info.get('session_duration', 0)
        if session_duration >= 1800:  # 30+ min
            score += 2
            reasons.append(f"Long session ({session_duration // 60} min)")
        elif session_duration >= 600:  # 10+ min
            score += 1
            reasons.append(f"Session ({session_duration // 60} min)")

        # File changes
        if file_changes:
            changed_files = [f for f in file_changes.split('\n') if f.strip()]
            significant_files = []
            for file_line in changed_files:
                if len(file_line) > 2:
                    filename = file_line[2:].strip()
                    is_trivial = any(re.search(p, filename) for p in self.filters['trivial_patterns'])
                    if not is_trivial:
                        significant_files.append(file_line)

            if len(significant_files) >= self.filters['minimum_changes']:
                score += 2
                reasons.append(f"Modified {len(significant_files)} files")

            for file_line in significant_files:
                if len(file_line) > 2:
                    filename = file_line[2:].strip()
                    for ext, weight in self.filters['file_weight'].items():
                        if filename.endswith(ext):
                            score += weight * 0.5
                            if weight >= 2.0:
                                reasons.append(f"Modified: {filename}")
                            break

        # Commits (main scoring factor)
        if recent_commits:
            commit_lines = [c for c in recent_commits.split('\n') if c.strip()]
            if commit_lines:
                score += 3 * len(commit_lines)
                reasons.append(f"Made {len(commit_lines)} commits")
                for commit in commit_lines:
                    for pattern in self.filters['significant_patterns']:
                        if re.search(pattern, commit, re.IGNORECASE):
                            score += 2
                            break

        # Lines changed
        if diff_stats or staged_stats:
            stats_text = f"{diff_stats} {staged_stats}"
            total_lines = sum(int(m) for m in re.findall(r'(\d+)\s+insertion', stats_text))
            total_lines += sum(int(m) for m in re.findall(r'(\d+)\s+deletion', stats_text))
            if total_lines >= self.filters['minimum_lines']:
                score += min(5, total_lines / 20)
                reasons.append(f"Changed {total_lines} lines")

        # Branch boost
        git_branch = session_info.get('git_branch', '').lower()
        if git_branch.startswith('feature/') or git_branch.startswith('fix/'):
            score += 1
            reasons.append(f"Branch: {git_branch}")

        return score, reasons

    def check_duplicate(self, content: str) -> bool:
        queue_file = Path.home() / ".claude" / "scripts" / "memory-queue.jsonl"
        if not queue_file.exists():
            return False
        content_hash = hashlib.md5(content.encode()).hexdigest()
        try:
            with open(queue_file, 'r') as f:
                for line in f.readlines()[-20:]:
                    record = json.loads(line)
                    if hashlib.md5(record.get('content', '').encode()).hexdigest() == content_hash:
                        return True
        except:
            pass
        return False

    def process_session(self, session_file: str):
        try:
            with open(session_file, 'r') as f:
                session_data = json.load(f)

            significance, reasons = self.calculate_significance(session_data)
            print(f"Session significance score: {significance:.1f}")
            print(f"Reasons: {', '.join(reasons)}")

            if significance < self.significance_threshold:
                print(f"Session not significant enough (threshold: {self.significance_threshold})")
                return

            session_info = session_data.get('session_data', {})
            project = session_info.get('project_name', 'Unknown')
            branch = session_info.get('git_branch', '')

            content = f"Claude session in {project}"
            if branch:
                content += f" on {branch}"
            if reasons:
                content += ". " + ". ".join(reasons[:3])

            if self.check_duplicate(content):
                print("Duplicate, skipping")
                return

            metadata = {
                'tags': ['session', 'automated', project],
                'project': project,
                'git_branch': branch,
                'significance_score': significance,
            }

            queue_file = Path.home() / ".claude" / "scripts" / "memory-queue.jsonl"
            with open(queue_file, 'a') as f:
                f.write(json.dumps({
                    "content": content,
                    "metadata": metadata,
                    "timestamp": datetime.now().isoformat()
                }) + '\n')
            print(f"Queued memory: {content[:80]}...")

        except Exception as e:
            print(f"Error: {e}")

def main():
    if len(sys.argv) < 2:
        print("Usage: process-session-memory.py <session_file>")
        sys.exit(1)
    if os.path.exists(sys.argv[1]):
        SessionMemoryProcessor().process_session(sys.argv[1])

if __name__ == "__main__":
    main()
PYEOF

chmod +x ~/.claude/scripts/process-session-memory.py
echo "Created: ~/.claude/scripts/process-session-memory.py"

# -----------------------------------------------------------------------------
# 3. Update settings.json with hooks
# -----------------------------------------------------------------------------
SETTINGS_FILE="$HOME/.claude/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
    echo "Existing settings.json found. Adding hooks..."

    # Check if hooks section exists
    if grep -q '"hooks"' "$SETTINGS_FILE"; then
        echo "Hooks section exists. Please manually add/verify these hooks:"
    else
        echo "No hooks section found. Please manually add to settings.json:"
    fi
else
    echo "Creating new settings.json..."
    cat > "$SETTINGS_FILE" << 'SETTINGSEOF'
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "date +%s > /tmp/claude_session_start.txt"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash(git commit*)",
        "hooks": [
          {
            "type": "command",
            "command": "CLAUDE_HOOK_TYPE=git_commit bash \"$HOME/.claude/hooks/session-memory.sh\""
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "CLAUDE_HOOK_TYPE=session_end bash \"$HOME/.claude/hooks/session-memory.sh\""
          }
        ]
      }
    ]
  }
}
SETTINGSEOF
fi

# -----------------------------------------------------------------------------
# 4. Print hooks config to add manually
# -----------------------------------------------------------------------------
echo ""
echo "=============================================="
echo "HOOKS TO ADD TO ~/.claude/settings.json"
echo "=============================================="
cat << 'HOOKSINFO'
Add these to your "hooks" section:

"SessionStart": [
  {
    "matcher": "startup",
    "hooks": [
      {
        "type": "command",
        "command": "date +%s > /tmp/claude_session_start.txt"
      }
    ]
  }
],
"PostToolUse": [
  {
    "matcher": "Bash(git commit*)",
    "hooks": [
      {
        "type": "command",
        "command": "CLAUDE_HOOK_TYPE=git_commit bash \"$HOME/.claude/hooks/session-memory.sh\""
      }
    ]
  }
],
"Stop": [
  {
    "matcher": "*",
    "hooks": [
      {
        "type": "command",
        "command": "CLAUDE_HOOK_TYPE=session_end bash \"$HOME/.claude/hooks/session-memory.sh\""
      }
    ]
  }
]
HOOKSINFO

echo ""
echo "=============================================="
echo "SETUP COMPLETE"
echo "=============================================="
echo ""
echo "Files created:"
echo "  - ~/.claude/hooks/session-memory.sh"
echo "  - ~/.claude/scripts/process-session-memory.py"
echo "  - ~/.claude/scripts/memory-queue.jsonl (will be created on first run)"
echo ""
echo "What gets stored:"
echo "  - Sessions with git commits"
echo "  - Sessions with significant code changes"
echo "  - NOT: research/chat sessions without commits"
echo ""
echo "Scoring (threshold: 5):"
echo "  - 1 commit = +3 pts"
echo "  - 10+ min session = +1 pt bonus"
echo "  - 30+ min session = +2 pt bonus"
echo "  - Feature/fix branch = +1 pt"
echo ""
echo "To test: Make a commit in any git repo, then check:"
echo "  tail -5 ~/.claude/logs/session-memory.log"
echo "  cat ~/.claude/scripts/memory-queue.jsonl"
