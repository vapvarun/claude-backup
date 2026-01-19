#!/bin/bash

# Plugin Memory Recall Hook
# Triggers at session start to recall plugin context from automem
# Saves tokens by providing pre-loaded context

PLUGIN_DIR=$(pwd)

# Check if we're in a WordPress plugin directory
is_wordpress_plugin() {
    # Check for main plugin file with Plugin Name header
    for f in "$PLUGIN_DIR"/*.php; do
        if [ -f "$f" ] && grep -q "Plugin Name:" "$f" 2>/dev/null; then
            return 0
        fi
    done
    return 1
}

# Exit if not a WordPress plugin
if ! is_wordpress_plugin; then
    exit 0
fi

# Get plugin info
PLUGIN_SLUG=$(basename "$PLUGIN_DIR")
MAIN_FILE=$(grep -l "Plugin Name:" "$PLUGIN_DIR"/*.php 2>/dev/null | head -1)
PLUGIN_NAME=$(grep "Plugin Name:" "$MAIN_FILE" 2>/dev/null | sed 's/.*Plugin Name:\s*//' | tr -d '\r')

# Check for CLAUDE.md
HAS_CLAUDE_MD="no"
if [ -f "$PLUGIN_DIR/CLAUDE.md" ]; then
    HAS_CLAUDE_MD="yes"
fi

# Check for architecture docs
HAS_ARCH_DOCS="no"
if [ -d "$PLUGIN_DIR/docs/architecture" ]; then
    HAS_ARCH_DOCS="yes"
fi

# Output context for Claude
cat << EOF
PLUGIN_CONTEXT_DETECTED:
- Slug: $PLUGIN_SLUG
- Name: $PLUGIN_NAME
- Main File: $(basename "$MAIN_FILE")
- Has CLAUDE.md: $HAS_CLAUDE_MD
- Has Architecture Docs: $HAS_ARCH_DOCS

RECOMMENDED_ACTIONS:
EOF

if [ "$HAS_CLAUDE_MD" = "no" ]; then
    cat << EOF
1. RUN ONBOARDING: This plugin needs setup
   /wp-plugin-onboard

   This will:
   - Generate architecture docs
   - Create CLAUDE.md
   - Index codebase for fast future access
EOF
else
    cat << EOF
1. READ CONTEXT: Load existing documentation
   Read: CLAUDE.md
   Read: docs/architecture/PLUGIN_ARCHITECTURE.md (if exists)

2. RECALL MEMORY: Get previous session context
   recall_memory({
     tags: ["$PLUGIN_SLUG"],
     limit: 10,
     time_query: "last 30 days"
   })

3. CHECK RECENT CHANGES:
   git log --oneline -5
EOF
fi
