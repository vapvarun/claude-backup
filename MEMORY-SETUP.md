# Memory Automation Setup

Copy-paste instructions for setting up automatic session memory on any Mac.

## Quick Setup (Tell Claude)

```
Set up memory automation from my backup:

1. Copy files:
   cp ~/claude-backup/hooks/session-memory.sh ~/.claude/hooks/
   cp ~/claude-backup/scripts/process-session-memory.py ~/.claude/scripts/
   chmod +x ~/.claude/hooks/session-memory.sh
   chmod +x ~/.claude/scripts/process-session-memory.py

2. Add these hooks to ~/.claude/settings.json in the "hooks" section:

   "SessionStart": [{"matcher": "startup", "hooks": [{"type": "command", "command": "date +%s > /tmp/claude_session_start.txt"}]}],
   "PostToolUse": [{"matcher": "Bash(git commit*)", "hooks": [{"type": "command", "command": "CLAUDE_HOOK_TYPE=git_commit bash \"$HOME/.claude/hooks/session-memory.sh\""}]}],
   "Stop": [{"matcher": "*", "hooks": [{"type": "command", "command": "CLAUDE_HOOK_TYPE=session_end bash \"$HOME/.claude/hooks/session-memory.sh\""}]}]

3. Create log directory:
   mkdir -p ~/.claude/logs
```

## What It Does

- Captures session start time on startup
- On session end, scores the session based on git activity
- Only stores sessions with real coding work (commits)
- Skips research/chat sessions (saves tokens)

## Scoring

| Activity | Points |
|----------|--------|
| 1 commit | +3 |
| 10+ min session | +1 |
| 30+ min session | +2 |
| Feature/fix branch | +1 |
| **Threshold** | **5** |

## Files

- `hooks/session-memory.sh` - Captures git context and duration
- `scripts/process-session-memory.py` - Scores and queues memories
- `setup-memory-automation.sh` - Full setup script (alternative)

## Verify

After a session with commits:
```bash
tail -10 ~/.claude/logs/session-memory.log
cat ~/.claude/scripts/memory-queue.jsonl
```
