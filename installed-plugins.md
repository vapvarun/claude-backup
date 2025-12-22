# Installed Plugins

*Last updated: December 22, 2025*

Plugins are installed from marketplaces using `claude plugin install`. They provide slash commands, agents, and hooks.

**Total: 14 plugins across 4 marketplaces**

---

## Quick Install All

```bash
# Anthropic Official (2 plugins)
claude plugin install document-skills@anthropic-agent-skills
claude plugin install example-skills@anthropic-agent-skills

# Claude Plugins Official (6 plugins)
claude plugin install code-review@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install security-guidance@claude-plugins-official

# Claude Toolbox (2 plugins)
claude plugin install cms-cultivator@claude-toolbox
claude plugin install cms-planner@claude-toolbox

# Claude Code Plugins Plus (4 plugins)
claude plugin install api-documentation-generator@claude-code-plugins-plus
claude plugin install creator-studio-pack@claude-code-plugins-plus
claude plugin install excel-analyst-pro@claude-code-plugins-plus
claude plugin install fullstack-starter-pack@claude-code-plugins-plus
```

---

## Installed Plugins Detail

### Anthropic Agent Skills (`@anthropic-agent-skills`) - 2 plugins

| Plugin | Commands | Description |
|--------|----------|-------------|
| `document-skills` | Various document skills | PDF, DOCX, PPTX, XLSX manipulation |
| `example-skills` | Example skills | Reference implementations |

```bash
claude plugin install document-skills@anthropic-agent-skills
claude plugin install example-skills@anthropic-agent-skills
```

### Claude Plugins Official (`@claude-plugins-official`) - 6 plugins

| Plugin | Commands | Description |
|--------|----------|-------------|
| `code-review` | `/code-review` | Review pull requests |
| `commit-commands` | `/commit`, `/commit-push-pr`, `/clean_gone` | Git commit workflows |
| `feature-dev` | `/feature-dev` | Guided feature development |
| `frontend-design` | Frontend design agents | UI/UX design assistance |
| `pr-review-toolkit` | `/review-pr` | Comprehensive PR review agents |
| `security-guidance` | Security agents | Security review and guidance |

```bash
claude plugin install code-review@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install security-guidance@claude-plugins-official
```

### Claude Toolbox (`@claude-toolbox`) - 2 plugins

| Plugin | Commands | Description |
|--------|----------|-------------|
| `cms-cultivator` | `/audit-*`, `/pr-*`, `/test-*`, `/docs-*`, `/quality-*` | CMS auditing, testing, PR workflows |
| `cms-planner` | `/functional-requirements` | Requirements documentation |

```bash
claude plugin install cms-cultivator@claude-toolbox
claude plugin install cms-planner@claude-toolbox
```

### Claude Code Plugins Plus (`@claude-code-plugins-plus`) - 4 plugins

| Plugin | Commands | Description |
|--------|----------|-------------|
| `api-documentation-generator` | `/generate-api-docs` | OpenAPI/Swagger documentation |
| `creator-studio-pack` | Creator tools | Content creation tools |
| `excel-analyst-pro` | Excel analysis | Advanced Excel/spreadsheet analysis |
| `fullstack-starter-pack` | `/component-generator`, `/prisma-schema-gen`, `/auth-setup`, etc. | Fullstack scaffolding |

```bash
claude plugin install api-documentation-generator@claude-code-plugins-plus
claude plugin install creator-studio-pack@claude-code-plugins-plus
claude plugin install excel-analyst-pro@claude-code-plugins-plus
claude plugin install fullstack-starter-pack@claude-code-plugins-plus
```

---

## Plugin Management Commands

```bash
# Browse and install interactively
claude /plugin

# List installed plugins
claude plugin list

# Update all plugins
claude plugin update --all

# Update specific plugin
claude plugin update plugin-name@marketplace

# Uninstall plugin
claude plugin uninstall plugin-name@marketplace

# View plugin info
claude plugin info plugin-name@marketplace
```

---

## Plugin vs Skill Reminder

| Type | Install | Invoke | Location |
|------|---------|--------|----------|
| **Plugin** | `claude plugin install` | User types `/command` | Marketplace |
| **Skill** | Copy SKILL.md file | Claude decides automatically | `~/.claude/skills/` |

Plugins are packages from marketplaces. Skills are local expertise files.

---

## Adding New Plugins

1. Browse available plugins: `claude /plugin`
2. Install: `claude plugin install name@marketplace`
3. Add to this file for backup
4. Restart Claude Code

---

*Note: Plugin configurations are stored in `~/.claude/settings.json`. This file lists plugins to reinstall, not their configs.*
