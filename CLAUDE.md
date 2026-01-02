# Claude Code Instructions

## IMPORTANT: Git Commits

**NEVER add co-author attribution to any git commits.**

When creating git commits:
- ❌ DO NOT include "Co-Authored-By: Claude <noreply@anthropic.com>"
- ❌ DO NOT include "🤖 Generated with [Claude Code]" footer
- ✅ Keep commit messages clean and professional
- ✅ Only include the actual commit message and description

This is a strict requirement for all projects.

---

## Claude Config Sync (Skills, Agents, Plugins)

**MANDATORY:** Keep `~/.claude/` and `~/claude-backup/` in sync.

### Locations
| Type | Active Location | Backup Location |
|------|-----------------|-----------------|
| Skills | `~/.claude/skills/` | `~/claude-backup/skills/` |
| Agents | `~/.claude/agents/` | `~/claude-backup/agents/` |
| Plugins | `~/.claude/plugins/` | `~/claude-backup/plugins/` |
| Hooks | `~/.claude/hooks/` | `~/claude-backup/hooks/` |

### When Creating/Updating Skills, Agents, or Plugins

**Always update BOTH locations:**

1. Make changes in `~/.claude/` (active location)
2. Copy to backup:
   ```bash
   cp -r ~/.claude/skills/<skill-name> ~/claude-backup/skills/
   cp -r ~/.claude/agents/<agent-name> ~/claude-backup/agents/
   cp -r ~/.claude/plugins/<plugin-name> ~/claude-backup/plugins/
   ```
3. Commit and push backup:
   ```bash
   cd ~/claude-backup && git add -A && git commit -m "Update <type>: <name>" && git push
   ```

### Daily Sync Check

At session start or when user asks to sync:
```bash
# Pull latest from backup repo
cd ~/claude-backup && git pull

# Check for differences
diff -rq ~/.claude/skills/ ~/claude-backup/skills/
diff -rq ~/.claude/agents/ ~/claude-backup/agents/
diff -rq ~/.claude/plugins/ ~/claude-backup/plugins/
```

### Quick Sync Commands

```bash
# Sync skills (backup → active)
rsync -av --delete ~/claude-backup/skills/ ~/.claude/skills/

# Sync skills (active → backup)
rsync -av --delete ~/.claude/skills/ ~/claude-backup/skills/

# Full sync check
diff -rq ~/.claude/skills/ ~/claude-backup/skills/ 2>/dev/null && echo "Skills in sync" || echo "Skills differ"
```

### Backup Repo
- **Location:** `~/claude-backup/`
- **Remote:** `https://github.com/vapvarun/claude-backup.git`
- **Branch:** `master`

---

## WPCS (WordPress Coding Standards) - Auto Check/Fix

**MANDATORY:** Before committing ANY PHP files, ALWAYS run the WPCS pre-commit MCP tool.

### Workflow for Commits with PHP Files:
1. Before running `git commit`, check if there are staged PHP files: `git diff --cached --name-only | grep '\.php$'`
2. If PHP files exist, run `mcp__wpcs__wpcs_pre_commit` FIRST
3. The MCP tool will auto-fix issues and re-stage files
4. Then proceed with `git commit`

### If Commit is Blocked by WPCS Hook:
If you see "WPCS: PHP Files Detected" and the commit is blocked:
1. Run `mcp__wpcs__wpcs_pre_commit` to fix issues
2. Retry the commit immediately

### Available WPCS MCP Tools:
- `wpcs_pre_commit` - Auto-fix staged files, re-stage, report issues (USE THIS)
- `wpcs_check_file` - Check a single PHP file
- `wpcs_fix_file` - Fix a single PHP file
- `wpcs_check_directory` - Check all PHP files in a directory

---

## Memory Instructions

### Simple Memory Commands

When the user says:
- **"save memory"** → Store the current conversation context
- **"remember this"** → Store important information from this session
- **"save for future"** → Store as high-importance memory (0.9+)
- **"remember my preference"** → Store as preference with importance 0.85

## What to Save Automatically

### Always Save (High Importance 0.9+):
- Bug fixes and their solutions
- Important decisions and rationale
- Architecture changes
- Production issues and resolutions
- Security-related changes

### Usually Save (Importance 0.8+):
- New features implemented
- Code patterns and best practices
- Workflow improvements
- Configuration changes
- API integrations

### Sometimes Save (Importance 0.7+):
- User preferences
- Tool usage patterns
- Learning and insights
- Refactoring patterns

### Don't Save:
- Casual conversation
- Trivial questions
- Temporary context
- Test/debug output

## Memory Storage Format

When storing memories, use this format:
```
Content: Clear, concise description
Tags: ["project-name", "feature-area", "type"]
Importance: 0.5-1.0 (higher = more important)
```

## Tag Guidelines

Use clear, hierarchical tags:
- Project: `wordpress`, `automem`, `learndash`
- Type: `bug-fix`, `feature`, `decision`, `preference`, `pattern`
- Area: `api`, `ui`, `database`, `deployment`, `testing`

Examples:
- `["wordpress", "learndash", "bug-fix"]`
- `["automem", "mcp", "configuration"]`
- `["preference", "coding-style", "typescript"]`

## Recall Strategy

At session start, automatically recall:
1. Project-specific memories (last 7 days)
2. User preferences and workflows
3. Recent errors/solutions in current project
4. Incomplete work from previous sessions

Use semantic search with relevant keywords based on:
- Current working directory
- Recent git commits
- User's initial request

---

## Basecamp Token Sync (IMPORTANT)

When Basecamp MCP shows "OAuth token expired" error:

### Quick Fix (Run Script)
```bash
~/.mcp-servers/basecamp-mcp-server/sync-token.sh
```
Then restart Claude Code.

### Manual Fix (If Script Fails)
1. User refreshes token in WordPress: `http://reign-release.local/wp-admin/options-general.php?page=basecamp-reader`
2. Claude reads token from WordPress DB:
```bash
cd /Users/varundubey/Local\ Sites/reign-release/app/public && wp eval '
$data = get_option("bcr_token_data");
echo "ACCESS_TOKEN=" . $data["access_token"] . "\n";
echo "REFRESH_TOKEN=" . $data["refresh_token"] . "\n";
'
```
3. Update BOTH config files with the tokens:
   - `/Users/varundubey/.mcp-servers/basecamp-mcp-server/config.json` (accessToken, refreshToken)
   - `/Users/varundubey/Library/Application Support/Claude/claude_desktop_config.json` (BASECAMP_ACCESS_TOKEN, BASECAMP_REFRESH_TOKEN env vars)
4. User restarts Claude Code

### Why Two Config Files?
Claude Code CLI passes environment variables to MCP servers and caches them internally. Both files MUST be updated for the fix to work reliably.

---

## WP Community Documents - Basecamp Project

Project: **WP Community Documents (Sayansi)**
Project ID: `44836778`

### Important Columns (Card Table)

| Column | URL | Use For |
|--------|-----|---------|
| **Functionality Issues (Bugs)** | https://3.basecamp.com/5798509/buckets/44836778/card_tables/columns/9294572132 | Bug reports and issues to fix |
| **Testing** | https://3.basecamp.com/5798509/buckets/44836778/card_tables/columns/9294572959 | Cards ready for QA testing |

### Workflow
1. Pick card from **Functionality Issues** column
2. Fix the issue and commit
3. Add comment to card with fix details
4. Move card to **Testing** column

---

## Basecamp Formatting

**IMPORTANT:** Always use HTML tags for formatting in Basecamp comments and descriptions.

### Required HTML Tags:
- `<strong>` for bold text
- `<br>` for line breaks (NOT `\n` or newlines)

✅ Correct:
```html
<strong>Fixed</strong> - Issue resolved<br><br><strong>Root Cause:</strong><br>Description here<br><br><strong>Testing Steps:</strong><br>1. Step one<br>2. Step two
```

❌ Wrong:
```
**Fixed** - Issue resolved

**Root Cause:**
Description here
```

Markdown `**` and regular newlines do NOT render in Basecamp - always use `<strong>` and `<br>` tags.

---

## BuddyPress Trac Ticket Workflow

### Debug Installation
- **Location**: `/Users/varundubey/Local Sites/buddypress-dev/app/public`
- **BuddyPress Plugin**: `/wp-content/plugins/BuddyPress/` (cloned from GitHub)
- **Debug Index**: `/BUDDYPRESS_DEBUG_INDEX.md` (at WordPress install level)
- **Theme**: BuddyX

### Ticket Workflow

For each BuddyPress Trac ticket:

1. **Fetch ticket details** from `https://buddypress.trac.wordpress.org/ticket/<number>`
   - If network fails, user provides ticket HTML

2. **Verify the issue**
   - Reproduce the bug locally
   - Understand root cause by reading relevant code

3. **Check for existing patches/PRs**
   - If patch exists: verify it works, prepare confirming comment
   - If no patch: implement fix

4. **Create fix branch** (if implementing)
   ```bash
   git checkout -b fix/ticket-<number>-<short-description>
   ```

5. **Implement and test fix**
   - Run WPCS checks before committing
   - Test the fix resolves the issue

6. **Create patch** (if needed)
   ```bash
   git diff --no-prefix master fix/ticket-<number>-<description> > ~/Desktop/<number>.patch
   ```

7. **Prepare Trac comment**
   - Natural developer voice (NOT AI tone)
   - Thank reporter and patch author
   - Describe what was tested and confirmed

8. **Update debug index**
   - Add ticket to "Active Issues Being Debugged" section
   - Add to "File Change Tracking" table

9. **Return to master**
   ```bash
   git checkout master
   ```

### Branch Naming
```
fix/ticket-<number>-<short-description>
```
Examples:
- `fix/ticket-8712-404-on-group-invite-link`
- `fix/ticket-9297-profile-visibility-xprofile-check`

### Trac Comment Style
- Concise, natural developer voice
- No AI-sounding phrases
- Thank reporter: `Thanks @username for the report`
- Thank patch author: `Thanks @username for the patch`
- Describe what was tested

Example:
```
Tested this locally and can confirm the fix works. With Extended Profiles
disabled, the Profile Visibility link no longer appears in Settings nav.

The fix is straightforward - just wrap the subnav registration in
`bp_is_active( 'xprofile' )`.

Thanks @reporter for the report and @patcher for the patch!
```

### Debug Index Location
All ticket info saved to: `/Users/varundubey/Local Sites/buddypress-dev/app/public/BUDDYPRESS_DEBUG_INDEX.md`

Contains:
- Component index with key files/functions
- Access control flow documentation
- Common issue patterns
- Active issues being debugged
- File change tracking table

---

## Team Guidelines for WordPress Development

### Security is Non-Negotiable

Every piece of code must:
- Sanitize all input (`sanitize_text_field()`, `absint()`, etc.)
- Escape all output (`esc_html()`, `esc_attr()`, `esc_url()`)
- Use nonces for form submissions
- Check capabilities before actions
- Use `$wpdb->prepare()` for all database queries with variables

### Communication Style

When writing any output:
- **Be human, not robotic** - Write as a helpful colleague would speak
- **Be friendly but professional** - Warm tone without being overly casual
- **No excessive emojis** - One emoji per message maximum, only when appropriate
- **No marketing speak** - Avoid words like "revolutionary", "game-changing", "seamless"
- **No filler words** - Skip "basically", "essentially", "simply", "just"
- **Be direct** - Get to the point, respect the reader's time

### Documentation Standards

When creating documentation:
- Write for real people, not search engines
- Use active voice
- Lead with the outcome, not the feature
- Include practical examples
- Add real screenshots from local development environment
- Keep sentences short and scannable
- Explain the "why", not just the "how"

### Skills Reference

| Task | Skill |
|------|-------|
| Plugin development | `wp-plugin-development` |
| Theme development | `wp-theme-development` |
| Gutenberg blocks | `wp-gutenberg-blocks` |
| Security review | `wp-security-review` |
| Performance audit | `wp-performance-review` |
| Debugging issues | `wp-debugging` |
| WooCommerce | `woocommerce` |
| Code review | `code-review` or `pr-review` |
| Team standards | `team-standards` |
| Client messages | `client-communication` |
| Writing docs | `documentation` |
| Testing | `testing` |
| Git workflow | `git-workflow` |

### Edge Cases to Always Check

**WordPress-Specific:**
- Post with no featured image
- User with no display name
- Taxonomy with no posts
- Empty widget areas
- Shortcode with no attributes
- Multisite subdirectory vs subdomain
- Missing translations
- First-time install (no saved options)
- Meta value of 0 vs meta not existing

**General:**
- Empty arrays and null values
- Zero and negative numbers
- Empty strings vs null
- Unicode and special characters
- Concurrent submissions (double-click)
- Network timeouts
- Missing API responses

### Commit Message Format
```
type(scope): brief description

feat(checkout): add express payment option
fix(cart): resolve quantity update on mobile
docs(readme): update installation steps
```

### Before Submitting Any Work

**Security Checklist:**
- [ ] Input sanitized
- [ ] Output escaped
- [ ] Nonces verified
- [ ] Capabilities checked
- [ ] Prepared statements used

**Quality Checklist:**
- [ ] WordPress standards followed
- [ ] Edge cases handled
- [ ] Error handling complete
- [ ] No debug code left behind
- [ ] Functions under 50 lines

**Documentation Checklist:**
- [ ] Code comments explain "why"
- [ ] DocBlocks on functions
- [ ] README updated if needed
- [ ] Changelog entry added

### Response Format

When responding to requests:
1. Acknowledge what you understood
2. Explain your approach briefly
3. Do the work
4. Summarize what was done
5. Mention any concerns or next steps

Keep responses focused and practical. Skip unnecessary pleasantries but maintain a friendly, collegial tone.
