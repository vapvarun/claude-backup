# Claude Code Hooks

Custom hooks that execute in response to Claude Code events.

## Installation

```bash
# Copy all hooks
cp *.sh ~/.claude/hooks/

# Make executable
chmod +x ~/.claude/hooks/*.sh
```

## Available Hooks

| Hook | Trigger | Purpose |
|------|---------|---------|
| `wpcs-pre-commit.sh` | Before PHP commits | WordPress Coding Standards check |
| `session-memory.sh` | Session events | Auto-save session context to memory |
| `capture-build-result.sh` | After builds | Capture build outcomes |
| `capture-code-pattern.sh` | Code changes | Learn code patterns |
| `capture-deployment.sh` | Deployments | Track deployment details |
| `capture-error-resolution.sh` | Error fixes | Remember error solutions |
| `capture-search-result.sh` | Searches | Track search patterns |
| `capture-test-pattern.sh` | Test runs | Learn testing patterns |

## Hook Types

Hooks can be triggered by:
- `PreToolUse` - Before a tool runs
- `PostToolUse` - After a tool completes
- `Notification` - On notifications
- `Stop` - When Claude stops

## Creating New Hooks

```bash
#!/bin/bash
# Hook script template

# Read input from stdin
input=$(cat)

# Parse event data
event_type=$(echo "$input" | jq -r '.event_type')

# Your logic here
echo '{"continue": true}'
```

## Configuration

Hooks are configured in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": ["~/.claude/hooks/your-hook.sh"]
      }
    ]
  }
}
```
