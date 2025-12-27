# Claude Code Skills & Configuration

Team skills and configuration for Claude Code, optimized for WordPress development.

## Quick Install (Any System)

### 1. Clone the repo

```bash
cd ~
git clone https://github.com/vapvarun/claude-backup.git
```

### 2. Copy to Claude config folder

**macOS/Linux:**
```bash
mkdir -p ~/.claude/skills
cp -r ~/claude-backup/skills/* ~/.claude/skills/
cp ~/claude-backup/CLAUDE.md ~/.claude/CLAUDE.md
```

**Windows (PowerShell):**
```powershell
mkdir -Force $env:USERPROFILE\.claude\skills
Copy-Item -Recurse $env:USERPROFILE\claude-backup\skills\* $env:USERPROFILE\.claude\skills\
Copy-Item $env:USERPROFILE\claude-backup\CLAUDE.md $env:USERPROFILE\.claude\CLAUDE.md
```

### 3. Verify installation

Open Claude Code and ask:
```
"List my available skills"
```

## Updating Skills

Pull latest and copy again:

```bash
cd ~/claude-backup
git pull
cp -r skills/* ~/.claude/skills/
cp CLAUDE.md ~/.claude/CLAUDE.md
```

## How Claude Uses These Skills

### Automatic Detection

Claude reads `CLAUDE.md` on every conversation and applies relevant skills based on context:

| Your Request | Skills Auto-Applied |
|--------------|---------------------|
| "Build a plugin" | wp-plugin-development, wp-security-review |
| "Review this code" | code-review, pr-review |
| "Write docs" | documentation |
| "Create marketing content" | marketing, email-marketing, social-media |
| "Fix this bug" | wp-debugging |
| "Is this secure?" | wp-security-review |

### Manual Invocation

Use `/skill [name]` to explicitly load a skill:

```
/skill wp-security-review
/skill marketing
/skill code-review
```

## Available Skills

### WordPress Development
| Skill | Use For |
|-------|---------|
| `wp-plugin-development` | Building plugins |
| `wp-theme-development` | Building themes |
| `wp-gutenberg-blocks` | Block editor development |
| `wp-security-review` | Security audits |
| `wp-performance-review` | Performance audits |
| `wp-debugging` | Debugging issues |
| `woocommerce` | WooCommerce development |

### Code Quality
| Skill | Use For |
|-------|---------|
| `code-review` | Reviewing code |
| `pr-review` | Pull request reviews with double verification |
| `team-standards` | Team coding conventions |
| `testing` | Writing tests (Jest, PHPUnit, Playwright) |
| `accessibility` | WCAG compliance |

### Frontend
| Skill | Use For |
|-------|---------|
| `frontend-design` | UI design and implementation |
| `css-styling` | CSS and responsive design |
| `react-component` | React development |
| `javascript` | JavaScript patterns |
| `typescript` | TypeScript development |

### Marketing & Communication
| Skill | Use For |
|-------|---------|
| `marketing` | Full marketing content packages |
| `email-marketing` | Email campaigns |
| `social-media` | Social media content |
| `client-communication` | Client emails and updates |
| `documentation` | User documentation |

### Other
| Skill | Use For |
|-------|---------|
| `git-workflow` | Git and branching |
| `api-endpoint` | REST API development |
| `database` | Database design |
| `devops` | Deployment and CI/CD |
| `seo-optimization` | SEO improvements |

## Team Guidelines (CLAUDE.md)

The master `CLAUDE.md` enforces:

### Security (Non-Negotiable)
- Sanitize all input
- Escape all output
- Use nonces for forms
- Check capabilities
- Use `$wpdb->prepare()`

### Double Verification
Before completing any task:
1. Security checklist
2. Quality checklist
3. Edge cases
4. WordPress standards

### Communication Style
- Human tone, not robotic
- Maximum one emoji per message
- No buzzwords (revolutionary, seamless, game-changing)
- No filler words (basically, simply, essentially)
- Direct and respectful of time

### Edge Cases to Check
- Post with no featured image
- User with no display name
- Empty arrays and null values
- Zero vs empty string vs null
- First-time install (no saved options)
- Meta value of 0 vs not existing

## For Claude: Self-Learning Instructions

When asked to update or learn from this repo:

1. Read `CLAUDE.md` for team guidelines
2. Scan `skills/` folder for available skills
3. Read relevant `skill.md` files based on task
4. Apply guidelines and patterns from skills
5. Follow double verification before completing work

To refresh your knowledge:
```
"Read the CLAUDE.md and skills in claude-backup repo and update your understanding"
```

## Contributing

1. Update skills in `claude-backup/skills/`
2. Update `CLAUDE.md` if adding team guidelines
3. Commit and push
4. Run install commands on other systems to sync
