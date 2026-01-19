#!/bin/bash

# Plugin Index Update Hook
# Runs after commits to update CLAUDE.md Recent Changes section
# Also stores significant changes in automem

PLUGIN_DIR=$(pwd)
CLAUDE_MD="$PLUGIN_DIR/CLAUDE.md"

# Check if we're in a WordPress plugin directory
if [ ! -f "$CLAUDE_MD" ]; then
    exit 0
fi

# Check if this looks like a WordPress plugin
if ! grep -q "Plugin Name:" "$PLUGIN_DIR"/*.php 2>/dev/null; then
    exit 0
fi

# Get plugin slug from directory name
PLUGIN_SLUG=$(basename "$PLUGIN_DIR")

# Get recent commit info
LAST_COMMIT=$(git log -1 --pretty=format:"%ad|%s" --date=short 2>/dev/null)
COMMIT_DATE=$(echo "$LAST_COMMIT" | cut -d'|' -f1)
COMMIT_MSG=$(echo "$LAST_COMMIT" | cut -d'|' -f2)

# Determine change type from commit message
if echo "$COMMIT_MSG" | grep -qi "^fix\|bug\|hotfix"; then
    CHANGE_TYPE="fix"
elif echo "$COMMIT_MSG" | grep -qi "^feat\|feature\|add"; then
    CHANGE_TYPE="feature"
elif echo "$COMMIT_MSG" | grep -qi "^refactor\|clean"; then
    CHANGE_TYPE="refactor"
elif echo "$COMMIT_MSG" | grep -qi "^docs\|readme"; then
    CHANGE_TYPE="docs"
else
    CHANGE_TYPE="update"
fi

# Get changed PHP files count
CHANGED_PHP=$(git diff --name-only HEAD~1 2>/dev/null | grep "\.php$" | wc -l | tr -d ' ')

# Log the update
echo "📝 Plugin index update: $PLUGIN_SLUG"
echo "   Type: $CHANGE_TYPE | Files: $CHANGED_PHP PHP files"

# Output for Claude to process
cat << EOF
PLUGIN_INDEX_UPDATE:
- Plugin: $PLUGIN_SLUG
- Date: $COMMIT_DATE
- Type: $CHANGE_TYPE
- Message: $COMMIT_MSG
- PHP Files Changed: $CHANGED_PHP

ACTION_REQUIRED:
1. Update CLAUDE.md Recent Changes table
2. If $CHANGED_PHP > 5, consider re-indexing: /codebase-architect --scope=verify
3. Store in memory if significant change:
   store_memory({
     content: "$PLUGIN_SLUG: $COMMIT_MSG",
     tags: ["$PLUGIN_SLUG", "wordpress", "$CHANGE_TYPE"],
     importance: 0.7
   })
EOF
