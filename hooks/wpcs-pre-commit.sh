#!/bin/bash

# WPCS Pre-Commit Hook for Claude Code
# Detects staged PHP files and triggers MCP-based WPCS check
# The actual fixing is done by the wpcs_pre_commit MCP tool

LOG_FILE="$HOME/.claude/logs/wpcs-hook.log"
mkdir -p "$(dirname "$LOG_FILE")"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_message "WPCS pre-commit hook triggered"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_message "Not in a git repository, skipping"
    exit 0
fi

# Get staged PHP files (Added, Copied, Modified - not Deleted)
STAGED_PHP=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.php$' || true)

if [ -z "$STAGED_PHP" ]; then
    log_message "No staged PHP files, skipping"
    exit 0
fi

# Check if this is a retry after MCP fix (marker file exists)
MARKER_FILE="/tmp/wpcs-checked-$(git rev-parse --short HEAD 2>/dev/null || echo 'new')"

if [ -f "$MARKER_FILE" ]; then
    log_message "WPCS already checked this commit, proceeding"
    rm -f "$MARKER_FILE"
    exit 0
fi

# Count PHP files
PHP_COUNT=$(echo "$STAGED_PHP" | wc -l | tr -d ' ')
log_message "Found $PHP_COUNT staged PHP file(s), triggering MCP check"

# Create marker so we don't loop
touch "$MARKER_FILE"

# Output message for Claude to see and act on
echo ""
echo "=========================================="
echo "  WPCS: PHP Files Detected"
echo "=========================================="
echo ""
echo "Found $PHP_COUNT staged PHP file(s):"
echo "$STAGED_PHP" | while read -r f; do echo "  - $f"; done
echo ""
echo "ACTION REQUIRED: Run wpcs_pre_commit MCP tool first."
echo ""

# Exit 2 blocks the commit - Claude should run wpcs_pre_commit then retry
exit 2
