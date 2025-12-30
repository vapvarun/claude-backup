# Skill Template (v2)

Based on learnings from [Automattic/agent-skills](https://github.com/Automattic/agent-skills).

## Directory Structure

```
skills/<skill-name>/
├── skill.md              # Main skill file (short, procedural)
├── references/           # Deep-dive documentation
│   ├── topic-a.md
│   ├── topic-b.md
│   └── debugging.md      # Always include debugging reference
└── scripts/              # Deterministic helpers (optional)
    └── detect_<x>.mjs    # Detection/validation scripts
```

## Skill File Format

```markdown
---
name: skill-name
description: "One-line description of when/what this skill handles"
compatibility: "Target versions (WP 6.9+, PHP 8.1+), agent type, dependencies"
---

# Skill Name

## When to use

Use this skill when:
- [specific trigger phrase or task type]
- [another trigger]
- [etc.]

## Inputs required

- [What information is needed before starting]
- [Environment constraints]
- [Target files/paths]

## Procedure

### 0) Triage / Discovery (if applicable)
[Detection and context gathering steps]

### 1) Step Name
[Clear instructions]

Read:
- `references/topic.md`

### 2) Another Step
[Instructions with explicit file references]

## Verification

- [How to confirm the task succeeded]
- [Tests to run]
- [Expected outcomes]

## Failure modes / debugging

- [Common failure]: [Quick fix]
- [Another failure]: [Resolution]

Read:
- `references/debugging.md`

## Escalation

- [When to ask for more info]
- [Canonical docs to consult]
- [Safety constraints]
```

## Key Principles

### 1. Keep SKILL.md Short
- Procedure should be scannable
- Deep explanations go in `references/`
- Link to references with `Read: references/topic.md`

### 2. Deterministic Over Guessing
- If something can be detected programmatically, add a script
- Scripts reduce AI hallucination and improve reliability

### 3. Clear Triggers
- "When to use" should have explicit phrases/patterns
- Make it easy to know when this skill applies

### 4. Structured Inputs
- Document what's needed before starting
- Prevents incomplete execution

### 5. Always Include
- Verification section (how to confirm success)
- Failure modes (common issues + fixes)
- Escalation (when to stop/ask)

## Migration from v1 Skills

If updating an existing skill:

1. Add YAML frontmatter (name, description, compatibility)
2. Add "When to use" section with trigger phrases
3. Add "Inputs required" section
4. Convert content to numbered procedure steps
5. Extract deep content to `references/` folder
6. Add "Verification" section
7. Add "Failure modes / debugging" section
8. Add "Escalation" section

## Example: Converting Old Skill

**Before (v1):**
```markdown
# Plugin Development

Build WordPress plugins following best practices...

## Security
[Long security content]

## Hooks
[Long hooks content]
```

**After (v2):**
```markdown
---
name: wp-plugin-development
description: "WordPress plugin architecture, hooks, security, settings API"
compatibility: "WordPress 6.9+ (PHP 8.1+). Filesystem agent."
---

# WP Plugin Development

## When to use
- Creating a new plugin
- Adding hooks/filters
- Settings API implementation
- Security review

## Inputs required
- Plugin directory path
- Target WP/PHP versions
- Single-site or multisite

## Procedure

### 1) Plugin structure
[Short instructions]
Read: `references/structure.md`

### 2) Security baseline
[Short instructions]
Read: `references/security.md`

## Verification
- Plugin activates without errors
- PHPCS passes
- Settings save correctly

## Failure modes
- Activation hook not firing → Check hook registration location
- Settings not saving → Verify nonce and capability checks

## Escalation
Consult WordPress Plugin Handbook for canonical patterns.
```
