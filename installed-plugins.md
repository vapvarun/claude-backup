# Installed Plugins

*Last updated: December 22, 2025*

Plugins are installed from marketplaces using `claude plugin install`. They provide slash commands, agents, and hooks.

---

## Quick Install All

```bash
# Anthropic Official
claude plugin install document-skills@anthropic-agent-skills
claude plugin install example-skills@anthropic-agent-skills

# Claude Plugins Official
claude plugin install code-review@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official

# Third-Party
claude plugin install cms-cultivator@claude-toolbox
claude plugin install cms-planner@claude-toolbox
claude plugin install fullstack-starter-pack@claude-code-plugins-plus
claude plugin install api-documentation-generator@claude-code-plugins-plus
```

---

## Installed Plugins Detail

### Anthropic Agent Skills (`@anthropic-agent-skills`)

| Plugin | Commands | Description |
|--------|----------|-------------|
| `document-skills` | Various document skills | PDF, DOCX, PPTX, XLSX manipulation |
| `example-skills` | Example skills | Reference implementations |

```bash
claude plugin install document-skills@anthropic-agent-skills
claude plugin install example-skills@anthropic-agent-skills
```

### Claude Plugins Official (`@claude-plugins-official`)

| Plugin | Commands | Description |
|--------|----------|-------------|
| `code-review` | `/code-review` | Review pull requests |
| `commit-commands` | `/commit`, `/commit-push-pr` | Git commit workflows |
| `pr-review-toolkit` | `/review-pr` | Comprehensive PR review agents |
| `feature-dev` | `/feature-dev` | Guided feature development |

```bash
claude plugin install code-review@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official
```

### Claude Toolbox (`@claude-toolbox`)

| Plugin | Commands | Description |
|--------|----------|-------------|
| `cms-cultivator` | `/audit-*`, `/pr-*`, `/test-*` | CMS auditing and testing |
| `cms-planner` | `/functional-requirements` | Requirements documentation |

```bash
claude plugin install cms-cultivator@claude-toolbox
claude plugin install cms-planner@claude-toolbox
```

### Claude Code Plugins Plus (`@claude-code-plugins-plus`)

| Plugin | Commands | Description |
|--------|----------|-------------|
| `fullstack-starter-pack` | `/component-generator`, `/prisma-schema-gen` | Fullstack scaffolding |
| `api-documentation-generator` | `/generate-api-docs` | OpenAPI documentation |

```bash
claude plugin install fullstack-starter-pack@claude-code-plugins-plus
claude plugin install api-documentation-generator@claude-code-plugins-plus
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
