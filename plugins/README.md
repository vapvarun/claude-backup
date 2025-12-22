# Plugins Directory

This directory is reserved for **custom plugins** (if any).

---

## Important Notes

1. **Marketplace plugins** are NOT stored here. They are installed via:
   ```bash
   claude plugin install plugin-name@marketplace
   ```

2. See [installed-plugins.md](../installed-plugins.md) for the list of marketplace plugins to install.

3. Custom plugins (if you create any) would go here with their full package structure.

---

## Plugin Structure (For Reference)

If you create a custom plugin, it follows this structure:

```
my-plugin/
├── package.json          # Plugin metadata
├── manifest.json         # Commands, agents, hooks
├── commands/             # Slash command prompts
│   └── my-command.md
├── agents/               # Agent definitions
│   └── my-agent.md
└── hooks/                # Hook scripts
    └── pre-commit.sh
```

---

## Installing Custom Plugins

Custom plugins can be installed from local paths:

```bash
claude plugin install ./path/to/my-plugin
```

Or from Git repositories:

```bash
claude plugin install github:username/my-plugin
```

---

*Currently no custom plugins in this backup.*
