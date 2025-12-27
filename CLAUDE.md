# Team Guidelines for Claude Code

This file defines team standards for all Claude Code interactions in WordPress development projects.

## Core Principles

### 1. WordPress Standards First

All code must follow WordPress coding standards:
- PHP: https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/
- JavaScript: https://developer.wordpress.org/coding-standards/wordpress-coding-standards/javascript/
- CSS: https://developer.wordpress.org/coding-standards/wordpress-coding-standards/css/

### 2. Security is Non-Negotiable

Every piece of code must:
- Sanitize all input (`sanitize_text_field()`, `absint()`, etc.)
- Escape all output (`esc_html()`, `esc_attr()`, `esc_url()`)
- Use nonces for form submissions
- Check capabilities before actions
- Use `$wpdb->prepare()` for all database queries with variables

### 3. Double Verification

Before completing any task:
1. Run security checklist
2. Run quality checklist
3. Test edge cases
4. Verify WordPress standards compliance

### 4. Communication Style

When writing any output:
- **Be human, not robotic** - Write as a helpful colleague would speak
- **Be friendly but professional** - Warm tone without being overly casual
- **No excessive emojis** - One emoji per message maximum, only when appropriate
- **No marketing speak** - Avoid words like "revolutionary", "game-changing", "seamless"
- **No filler words** - Skip "basically", "essentially", "simply", "just"
- **Be direct** - Get to the point, respect the reader's time

### 5. Documentation Standards

When creating documentation:
- Write for real people, not search engines
- Use active voice
- Lead with the outcome, not the feature
- Include practical examples
- Add real screenshots from local development environment
- Keep sentences short and scannable
- Explain the "why", not just the "how"

## Skills to Use

For WordPress development, use these skills:

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

## Edge Cases to Always Check

### WordPress-Specific
- Post with no featured image
- User with no display name
- Taxonomy with no posts
- Empty widget areas
- Shortcode with no attributes
- Multisite subdirectory vs subdomain
- Missing translations
- First-time install (no saved options)
- Meta value of 0 vs meta not existing

### General
- Empty arrays and null values
- Zero and negative numbers
- Empty strings vs null
- Unicode and special characters
- Concurrent submissions (double-click)
- Network timeouts
- Missing API responses

## Commit and PR Standards

### Commit Messages
```
type(scope): brief description

feat(checkout): add express payment option
fix(cart): resolve quantity update on mobile
docs(readme): update installation steps
```

### PR Descriptions
Every PR needs:
- Summary of changes
- Type of change (bug fix, feature, etc.)
- How to test
- Security checklist
- Related issues

## Before Submitting Any Work

Run this checklist:

### Security
- [ ] Input sanitized
- [ ] Output escaped
- [ ] Nonces verified
- [ ] Capabilities checked
- [ ] Prepared statements used

### Quality
- [ ] WordPress standards followed
- [ ] Edge cases handled
- [ ] Error handling complete
- [ ] No debug code left behind
- [ ] Functions under 50 lines

### Documentation
- [ ] Code comments explain "why"
- [ ] DocBlocks on functions
- [ ] README updated if needed
- [ ] Changelog entry added

## Local Development Setup for Screenshots

When documentation requires screenshots:
1. Use a clean local WordPress installation
2. Use sample data that looks realistic
3. Highlight relevant UI elements with arrows or boxes
4. Crop to relevant area
5. Ensure no sensitive data visible
6. Use consistent browser/window size

## MCP Tools Available

The following MCP tools are available for documentation and project management:
- Basecamp integration for project updates
- Use these for real-time documentation needs

## Response Format Preferences

When responding to requests:
1. Acknowledge what you understood
2. Explain your approach briefly
3. Do the work
4. Summarize what was done
5. Mention any concerns or next steps

Keep responses focused and practical. Skip unnecessary pleasantries but maintain a friendly, collegial tone.
