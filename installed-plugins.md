# Installed Plugins

*Last updated: December 22, 2025*

Plugins are installed from marketplaces using `claude plugin install`. They provide slash commands, agents, and hooks.

**Total: 18 plugins across 4 marketplaces**

---

## Quick Install All

```bash
# Anthropic Official (2 plugins)
claude plugin install document-skills@anthropic-agent-skills
claude plugin install example-skills@anthropic-agent-skills

# Claude Plugins Official (10 plugins)
claude plugin install code-review@claude-plugins-official
claude plugin install commit-commands@claude-plugins-official
claude plugin install feature-dev@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install hookify@claude-plugins-official
claude plugin install playwright@claude-plugins-official
claude plugin install plugin-dev@claude-plugins-official
claude plugin install pr-review-toolkit@claude-plugins-official
claude plugin install ralph-wiggum@claude-plugins-official
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

| Plugin | Description |
|--------|-------------|
| `document-skills` | PDF, DOCX, PPTX, XLSX manipulation |
| `example-skills` | Reference implementations |

### Claude Plugins Official (`@claude-plugins-official`) - 10 plugins

| Plugin | Commands | Description |
|--------|----------|-------------|
| `code-review` | `/code-review` | PR reviews with confidence scoring |
| `commit-commands` | `/commit`, `/commit-push-pr`, `/clean_gone` | Git workflow automation |
| `feature-dev` | `/feature-dev` | 7-phase feature development |
| `frontend-design` | Frontend agents | Production-quality UI design |
| `hookify` | Hook creation | Custom hooks to prevent unwanted behaviors |
| `playwright` | Browser testing | E2E browser automation testing |
| `plugin-dev` | Plugin development | 8-phase workflow for building Claude Code plugins |
| `pr-review-toolkit` | `/review-pr` | Specialized PR review agents |
| `ralph-wiggum` | Autonomous iteration | Loops enabling Claude to work iteratively |
| `security-guidance` | Security hooks | Security warnings on file edits |

### Claude Toolbox (`@claude-toolbox`) - 2 plugins

| Plugin | Commands | Description |
|--------|----------|-------------|
| `cms-cultivator` | `/audit-*`, `/pr-*`, `/test-*`, `/docs-*`, `/quality-*` | CMS auditing, testing, PR workflows |
| `cms-planner` | `/functional-requirements` | Requirements documentation |

### Claude Code Plugins Plus (`@claude-code-plugins-plus`) - 4 plugins

| Plugin | Commands | Description |
|--------|----------|-------------|
| `api-documentation-generator` | `/generate-api-docs` | OpenAPI/Swagger documentation |
| `creator-studio-pack` | Creator tools | Content creation tools |
| `excel-analyst-pro` | Excel analysis | Advanced Excel/spreadsheet analysis |
| `fullstack-starter-pack` | `/component-generator`, `/prisma-schema-gen`, `/auth-setup` | Fullstack scaffolding |

---

## Plugin Management Commands

```bash
# Browse and install interactively
claude /plugin

# List marketplaces
claude plugin marketplace list

# Update all plugins
claude plugin update --all

# Uninstall plugin
claude plugin uninstall plugin-name@marketplace
```

---

## Web Agency Recommended Stack

For WordPress/WooCommerce web development agency:

| Plugin | Why |
|--------|-----|
| `code-review` | Quality control on PRs |
| `commit-commands` | Streamlined git workflow |
| `feature-dev` | Structured feature development |
| `hookify` | Enforce coding standards |
| `playwright` | E2E testing for client sites |
| `pr-review-toolkit` | Thorough PR reviews |
| `security-guidance` | Security checks |
| `cms-cultivator` | WordPress/CMS workflows |

---

*Note: Plugins are from marketplaces, not local files. Restart Claude Code after installing.*
