# Claude Code Instructions

## Git Commits
**NEVER add co-author attribution to git commits.**
- No "Co-Authored-By: Claude" lines
- No "Generated with Claude Code" footer

---

## WordPress Plugin Workflow (100+ Plugins)

### On Clone/First Visit
When cloning or entering a plugin directory:

1. **Check for CLAUDE.md** - If missing, run `/wp-plugin-onboard`
2. **Read existing docs** - `CLAUDE.md` + `docs/architecture/PLUGIN_ARCHITECTURE.md`
3. **Recall memory** - `recall_memory({ tags: ["plugin-slug"], limit: 10 })`

### After Code Changes
After commits, update index:
1. Update CLAUDE.md "Recent Changes" table
2. If 5+ files changed, verify docs: `/codebase-architect --scope=verify`
3. Store significant changes in memory

### Memory Tags
Always use consistent tags for plugins:
```
["plugin-slug", "wordpress", "type"]
```
Types: `bug-fix`, `feature`, `refactor`, `architecture`

---

## Project Workflows
- **BuddyPress**: `/Users/varundubey/Local Sites/buddypress-dev/CLAUDE.md`
- **Basecamp**: `~/.claude/workflows/basecamp.md`
- **WP Blog**: `~/.claude/workflows/wp-blog.md`

---

## Config Sync
Keep `~/.claude/` synced with `~/claude-backup/`
