# Claude Code Configuration Backup

Personal backup of Claude Code skills and plugin configurations for web development.

## Repository Structure

```
claude-backup/
├── README.md                # This file - Installation guide
├── skills/                  # Standalone skills (39 total)
│   ├── wp-plugin-development/
│   ├── laravel/
│   └── ...
├── plugins/                 # Custom plugins (if any)
│   └── README.md
└── installed-plugins.md     # Marketplace plugins to install
```

---

## Skills vs Plugins (Important!)

| Type | Location | Invocation | Install Method |
|------|----------|------------|----------------|
| **Skills** | `~/.claude/skills/` | Model-invoked (Claude decides) | Copy files |
| **Plugins** | Via marketplace | User-invoked (`/command`) | `claude plugin install` |

**Skills** = Expertise files (SKILL.md) that Claude uses automatically
**Plugins** = Packages with commands, agents, hooks from marketplaces

---

## Quick Install

### 1. Install Skills (Copy Files)

```bash
# Clone this repo
git clone https://github.com/vapvarun/claude-backup.git
cd claude-backup

# Create skills directory if needed
mkdir -p ~/.claude/skills

# Copy all skills
cp -r skills/* ~/.claude/skills/

# Verify
ls ~/.claude/skills/
```

### 2. Install Plugins (From Marketplace)

```bash
# Official plugins
claude plugin install document-skills@anthropic-agent-skills
claude plugin install code-review@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official

# Third-party plugins
claude plugin install cms-cultivator@claude-toolbox
claude plugin install fullstack-starter-pack@claude-code-plugins-plus
```

### 3. Restart Claude Code

Skills and plugins load on startup.

---

## Available Skills (39)

### WordPress & WooCommerce (7)

| Skill | Description |
|-------|-------------|
| `wp-plugin-development` | Plugin architecture, REST API, hooks system |
| `wp-theme-development` | Classic & block themes, template hierarchy |
| `wp-gutenberg-blocks` | Gutenberg block development, FSE, theme.json |
| `wp-security-review` | Security audit, OWASP Top 10, vulnerabilities |
| `wp-performance-review` | Performance optimization, anti-patterns |
| `wp-debugging` | WordPress debugging techniques |
| `woocommerce` | E-commerce, payment gateways, custom products |

### PHP & Laravel (2)

| Skill | Description |
|-------|-------------|
| `php` | Modern PHP 8.x: OOP, type safety, testing |
| `laravel` | Eloquent, Blade, Pest/PHPUnit, queues |

### Frontend & UI (7)

| Skill | Description |
|-------|-------------|
| `frontend-design` | Production-grade UI design |
| `react-component` | React components with TypeScript, hooks |
| `css-styling` | Modern CSS, responsive design, animations |
| `html-markup` | Semantic HTML5, accessibility |
| `javascript` | Modern JS/ES6+ best practices |
| `typescript` | TypeScript generics, utility types |
| `landing-page` | High-converting landing pages |

### Backend & API (3)

| Skill | Description |
|-------|-------------|
| `api-endpoint` | REST/GraphQL API development |
| `graphql` | GraphQL schemas, resolvers, Apollo |
| `database` | Schema design, indexing, optimization |

### Testing & Quality (4)

| Skill | Description |
|-------|-------------|
| `testing` | Unit, integration, E2E testing |
| `code-review` | Code review best practices |
| `accessibility` | WCAG 2.1 AA, ARIA, screen readers |
| `bug-fix` | Systematic debugging approach |

### Security & DevOps (3)

| Skill | Description |
|-------|-------------|
| `security` | OWASP Top 10, auth, validation |
| `devops` | Docker, CI/CD, deployment |
| `mcp-builder` | MCP server development guide |

### Content & Marketing (7)

| Skill | Description |
|-------|-------------|
| `documentation` | Technical documentation |
| `marketing` | Product marketing, announcements |
| `seo-optimization` | On-page SEO, Core Web Vitals |
| `email-marketing` | Email campaigns, newsletters |
| `social-media` | Social content, engagement |
| `customer-support` | Support ticket handling |
| `git-workflow` | Git best practices, commits, PRs |

### Utilities (6)

| Skill | Description |
|-------|-------------|
| `pdf` | PDF manipulation, extraction |
| `xlsx` | Excel spreadsheet analysis |
| `skill-creator` | Create new Claude Code skills |
| `web-artifacts-builder` | React + Tailwind + shadcn/ui |
| `webapp-testing` | Playwright browser testing |
| `theme-factory` | Theming toolkit with pre-built themes |

---

## Marketplace Plugins

Plugins must be installed from marketplaces (not copied). See [installed-plugins.md](installed-plugins.md).

### Install All Recommended Plugins

```bash
# Anthropic Official
claude plugin install document-skills@anthropic-agent-skills
claude plugin install example-skills@anthropic-agent-skills

# Claude Plugins Official
claude plugin install code-review@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install security-guidance@claude-plugins-official

# Third-Party
claude plugin install cms-cultivator@claude-toolbox
claude plugin install cms-planner@claude-toolbox
claude plugin install fullstack-starter-pack@claude-code-plugins-plus
claude plugin install api-documentation-generator@claude-code-plugins-plus
claude plugin install excel-analyst-pro@claude-code-plugins-plus
claude plugin install creator-studio-pack@claude-code-plugins-plus
```

### Plugin Commands

```bash
# Browse and install interactively
claude /plugin

# List installed
claude plugin list

# Update all
claude plugin update --all

# Uninstall
claude plugin uninstall plugin-name@marketplace
```

---

## Skill File Structure

Each skill is a folder with SKILL.md:

```
skill-name/
└── SKILL.md    # Required
```

### SKILL.md Format

```yaml
---
name: skill-name
description: When Claude should use this skill (trigger keywords)
---

# Skill Title

## Overview
What this skill provides.

## Guidelines
Instructions for Claude.

## Examples
Code patterns (BAD/GOOD).
```

---

## Creating New Skills

```bash
# Create skill folder
mkdir ~/.claude/skills/my-skill

# Create SKILL.md
cat > ~/.claude/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: Use this skill when working with X
---

# My Skill

## Guidelines
1. Step one
2. Step two

## Examples
```code
// Example here
```
EOF

# Restart Claude Code
```

---

## Sync & Backup

### Backup Local to Repo

```bash
cd ~/path/to/claude-backup

# Sync skills
rsync -av ~/.claude/skills/ skills/

# Save plugin list
claude plugin list > installed-plugins.md

# Commit
git add -A
git commit -m "Backup skills and plugin list"
git push
```

### Restore from Repo

```bash
# Clone
git clone https://github.com/vapvarun/claude-backup.git
cd claude-backup

# Install skills
cp -r skills/* ~/.claude/skills/

# Install plugins (from installed-plugins.md)
# Run the plugin install commands listed there
```

---

## File Locations Reference

| Type | Location | Purpose |
|------|----------|---------|
| Personal skills | `~/.claude/skills/` | Your custom skills |
| Project skills | `.claude/skills/` | Team skills (git) |
| Settings | `~/.claude/settings.json` | Plugin config |
| Plugin cache | `~/.claude/plugins/cache/` | Don't edit |

---

## Troubleshooting

### Skills not detected
1. Check file exists: `ls ~/.claude/skills/skill-name/SKILL.md`
2. Check SKILL.md has valid `description` in frontmatter
3. Restart Claude Code

### Plugins not working
```bash
# Debug mode
claude --debug

# Reinstall
claude plugin uninstall name@marketplace
claude plugin install name@marketplace
```

---

## Sources

- [Claude Code Docs](https://docs.anthropic.com/en/docs/claude-code)
- [anthropics/skills](https://github.com/anthropics/skills)
- [claude-plugins-official](https://github.com/anthropics/claude-plugins-official)

---

*Last updated: December 22, 2025 | Skills: 39*
