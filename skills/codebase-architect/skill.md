# Codebase Architect - Self-Verifying Documentation Generator

Generate exhaustive architecture documentation for any WordPress plugin/theme with **built-in self-checking, progress tracking, and verification loops**.

## Scope Parameter (IMPORTANT)

Choose documentation scope based on codebase size:

```
/codebase-architect <path> --scope=<level>
```

| Scope | Coverage Target | Best For | Output Size |
|-------|----------------|----------|-------------|
| `architectural` | Conceptual 95%, Reference 15% | Large codebases (500+ files) | 2,000-4,000 lines |
| `hybrid` | Conceptual 95%, Reference 50% | Medium codebases (50-500 files) | 4,000-8,000 lines |
| `reference` | Conceptual 95%, Reference 90%+ | Small codebases (<50 files) | 8,000+ lines |
| `verify` | Verification only | Check existing docs | Report only |

### Scope Details

**`--scope=architectural`** (Default)
- Documents all subsystems conceptually
- Includes key classes, functions, hooks
- Focus on patterns and workflows
- Does NOT list every item

**`--scope=hybrid`**
- Everything in architectural
- PLUS top 50 classes with full details
- PLUS top 100 functions
- PLUS all public hooks (~100-200)
- PLUS complete REST API table

**`--scope=reference`**
- Everything in hybrid
- PLUS all classes
- PLUS all functions (grouped by component)
- PLUS all hooks with parameters
- WARNING: May produce 10,000+ lines for large codebases

**`--scope=verify`**
- Runs enumeration only
- Compares against existing documentation
- Generates coverage report
- Does NOT modify documentation

### Size Recommendations

| Codebase Size | Files | Recommended Scope |
|---------------|-------|-------------------|
| Small | <50 | `reference` |
| Medium | 50-200 | `hybrid` |
| Large | 200-500 | `hybrid` or `architectural` |
| Very Large | 500+ | `architectural` |

**Example: BuddyPress**
- Files: 500+
- Items: 5,400+
- Recommended: `architectural`
- Result: 3,600 lines, 56 sections, 95% conceptual coverage

---

## Design Principle: No Human Intervention

```
┌──────────────────────────────────────────────────────────────────┐
│                    SELF-VERIFYING LOOP                          │
│                                                                  │
│   Enumerate → Document → Verify → Gap? → Fill → Verify → Done   │
│       ↑                              │                          │
│       └──────────────────────────────┘                          │
│              (automatic retry until 100%)                        │
└──────────────────────────────────────────────────────────────────┘
```

## Usage

```
/codebase-architect <path-to-plugin-or-theme>
```

---

## Phase 0: Initialize Manifest (CRITICAL)

Before ANY documentation, create a **manifest file** that tracks EVERY discoverable item.

### Create Manifest Structure

```bash
# Create manifest directory
mkdir -p <output-dir>/manifest

# Generate manifest files (one per category)
touch <output-dir>/manifest/classes.txt
touch <output-dir>/manifest/functions.txt
touch <output-dir>/manifest/hooks.txt
touch <output-dir>/manifest/rest-endpoints.txt
touch <output-dir>/manifest/ajax-handlers.txt
touch <output-dir>/manifest/js-files.txt
touch <output-dir>/manifest/db-tables.txt
touch <output-dir>/manifest/templates.txt
touch <output-dir>/manifest/blocks.txt
touch <output-dir>/manifest/shortcodes.txt
touch <output-dir>/manifest/widgets.txt
touch <output-dir>/manifest/cpt-taxonomies.txt
touch <output-dir>/manifest/admin-pages.txt
touch <output-dir>/manifest/cron-jobs.txt
touch <output-dir>/manifest/cli-commands.txt

# Master progress tracker
touch <output-dir>/manifest/PROGRESS.md
```

### Manifest Format

Each manifest file uses this format:
```
# <category> Manifest
# Generated: <timestamp>
# Source: <plugin-path>
# Total: <count>

[ ] item_name | file.php:123 | status:pending
[ ] item_name | file.php:456 | status:pending
[x] item_name | file.php:789 | status:documented
```

### Progress Tracker (PROGRESS.md)

```markdown
# Documentation Progress

## Overall Status
- **Started:** <timestamp>
- **Current Phase:** <phase-name>
- **Coverage:** <percentage>%

## Category Progress
| Category | Discovered | Documented | Coverage |
|----------|------------|------------|----------|
| Classes | 0 | 0 | 0% |
| Functions | 0 | 0 | 0% |
| Hooks | 0 | 0 | 0% |
| REST Endpoints | 0 | 0 | 0% |
| AJAX Handlers | 0 | 0 | 0% |
| JS Files | 0 | 0 | 0% |
| DB Tables | 0 | 0 | 0% |
| Templates | 0 | 0 | 0% |
| Blocks | 0 | 0 | 0% |
| Shortcodes | 0 | 0 | 0% |
| Widgets | 0 | 0 | 0% |
| CPT/Taxonomies | 0 | 0 | 0% |
| Admin Pages | 0 | 0 | 0% |
| Cron Jobs | 0 | 0 | 0% |
| CLI Commands | 0 | 0 | 0% |

## Verification Runs
| Run | Timestamp | Coverage | Gaps Found |
|-----|-----------|----------|------------|
| 1 | - | - | - |

## Gap Log
<!-- Automatically populated -->
```

---

## Phase 1: Enumeration (Populate Manifest)

Run ALL enumeration commands and populate manifest files.

### Enumeration Agent Batch (Run in Parallel)

**IMPORTANT:** Each agent MUST write to its manifest file with status:pending

#### Agent 1: Classes
```bash
grep -rn "^class \|^abstract class \|^trait \|^interface " --include="*.php" <path> | \
  grep -v "vendor\|node_modules\|tests" | \
  awk -F: '{print "[ ] " $2 " | " $1 ":" $2 " | status:pending"}' >> manifest/classes.txt
```

#### Agent 2: Functions
```bash
grep -rn "^function [a-z_]" --include="*.php" <path> | \
  grep -v "vendor\|node_modules\|tests" | \
  awk -F: '{print "[ ] " $3 " | " $1 ":" $2 " | status:pending"}' >> manifest/functions.txt
```

#### Agent 3: Hooks (Actions)
```bash
grep -rohn "do_action\s*(\s*['\"][^'\"]*['\"]" --include="*.php" <path> | \
  grep -v "vendor" | \
  sed "s/do_action\s*(\s*['\"]//; s/['\"].*//" | \
  sort -u | \
  awk '{print "[ ] " $1 " | action | status:pending"}' >> manifest/hooks.txt
```

#### Agent 4: Hooks (Filters)
```bash
grep -rohn "apply_filters\s*(\s*['\"][^'\"]*['\"]" --include="*.php" <path> | \
  grep -v "vendor" | \
  sed "s/apply_filters\s*(\s*['\"]//; s/['\"].*//" | \
  sort -u | \
  awk '{print "[ ] " $1 " | filter | status:pending"}' >> manifest/hooks.txt
```

#### Agent 5: REST Endpoints
```bash
grep -rn "register_rest_route" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/rest-endpoints.txt
```

#### Agent 6: AJAX Handlers
```bash
grep -rn "wp_ajax_\|admin-ajax" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/ajax-handlers.txt
```

#### Agent 7: JavaScript Files
```bash
find <path> -name "*.js" -not -path "*/node_modules/*" -not -path "*/vendor/*" -not -name "*.min.js" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/js-files.txt
```

#### Agent 8: Database Tables
```bash
grep -rn "CREATE TABLE\|\$wpdb->prefix\s*\.\s*['\"]" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/db-tables.txt
```

#### Agent 9: Templates
```bash
find <path> -name "*.php" -path "*/templates/*" -o -name "*-template.php" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/templates.txt
```

#### Agent 10: Blocks
```bash
find <path> -name "block.json" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/blocks.txt
grep -rn "register_block_type" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/blocks.txt
```

#### Agent 11: Shortcodes
```bash
grep -rn "add_shortcode" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/shortcodes.txt
```

#### Agent 12: Widgets
```bash
grep -rn "extends WP_Widget\|register_widget" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/widgets.txt
```

#### Agent 13: CPT & Taxonomies
```bash
grep -rn "register_post_type\|register_taxonomy" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/cpt-taxonomies.txt
```

#### Agent 14: Admin Pages
```bash
grep -rn "add_menu_page\|add_submenu_page\|add_options_page" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/admin-pages.txt
```

#### Agent 15: Cron Jobs
```bash
grep -rn "wp_schedule_event\|wp_schedule_single_event" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/cron-jobs.txt
```

#### Agent 16: CLI Commands
```bash
grep -rn "WP_CLI::add_command\|extends WP_CLI_Command" --include="*.php" <path> | \
  grep -v "vendor" | \
  awk '{print "[ ] " $0 " | status:pending"}' >> manifest/cli-commands.txt
```

### Post-Enumeration: Update Progress

After all agents complete, update PROGRESS.md:

```bash
# Count items in each manifest
for file in manifest/*.txt; do
  category=$(basename "$file" .txt)
  total=$(grep -c "status:pending\|status:documented" "$file" 2>/dev/null || echo 0)
  documented=$(grep -c "status:documented" "$file" 2>/dev/null || echo 0)
  echo "$category: $documented / $total"
done
```

---

## Phase 2: Documentation (With Progress Updates)

For each category, launch a documentation agent that:
1. Reads from manifest
2. Documents each item
3. Updates manifest status to `status:documented`
4. Updates PROGRESS.md

### Documentation Agent Template

```
AGENT INSTRUCTIONS:

1. Read manifest/<category>.txt
2. For each item with status:pending:
   a. Read the source file
   b. Generate documentation
   c. Append to architecture document
   d. Update manifest: change [ ] to [x] and status:pending to status:documented
   e. Increment documented count in PROGRESS.md

3. CRITICAL: After documenting each item, IMMEDIATELY update:
   - The manifest file (mark as documented)
   - The progress tracker

4. If an item cannot be documented (e.g., file not found), mark as:
   [!] item_name | file.php:123 | status:error | reason:<why>
```

### Documentation Agents (Run in Parallel Batches)

**Batch A (Core)**
- Agent: Document Classes (read manifest/classes.txt)
- Agent: Document Functions (read manifest/functions.txt)
- Agent: Document Hooks (read manifest/hooks.txt)

**Batch B (API Layer)**
- Agent: Document REST Endpoints (read manifest/rest-endpoints.txt)
- Agent: Document AJAX Handlers (read manifest/ajax-handlers.txt)
- Agent: Document Shortcodes (read manifest/shortcodes.txt)

**Batch C (Data Layer)**
- Agent: Document DB Tables (read manifest/db-tables.txt)
- Agent: Document CPT/Taxonomies (read manifest/cpt-taxonomies.txt)

**Batch D (UI Layer)**
- Agent: Document Templates (read manifest/templates.txt)
- Agent: Document Blocks (read manifest/blocks.txt)
- Agent: Document Widgets (read manifest/widgets.txt)
- Agent: Document Admin Pages (read manifest/admin-pages.txt)

**Batch E (Support)**
- Agent: Document JS Files (read manifest/js-files.txt)
- Agent: Document Cron Jobs (read manifest/cron-jobs.txt)
- Agent: Document CLI Commands (read manifest/cli-commands.txt)

---

## Phase 3: Self-Verification Loop

**AUTOMATIC - Runs after Phase 2 completes**

### Verification Agent

```
VERIFICATION AGENT INSTRUCTIONS:

1. Read PROGRESS.md to get current coverage

2. For each manifest file:
   a. Count items with status:pending (gaps)
   b. Count items with status:documented (done)
   c. Count items with status:error (problems)
   d. Calculate coverage percentage

3. If ANY category has coverage < 100%:
   a. Log gaps to PROGRESS.md "Gap Log" section
   b. Return status: INCOMPLETE
   c. Trigger Phase 4 (Gap Filling)

4. If ALL categories have coverage = 100%:
   a. Run cross-reference check (Phase 3b)
   b. If cross-reference passes: Return status: COMPLETE
   c. If cross-reference fails: Log issues, trigger fix

5. Update Verification Runs table in PROGRESS.md
```

### Cross-Reference Verification (Phase 3b)

```
CROSS-REFERENCE AGENT INSTRUCTIONS:

1. For each documented class in architecture file:
   - Verify class exists in codebase
   - Verify file path is correct
   - Flag any stale references

2. For each documented function:
   - Verify function exists
   - Verify signature matches

3. For each documented hook:
   - Verify hook is still called in codebase
   - Flag removed hooks

4. Output:
   - Stale references to remove
   - Mismatched signatures to fix
   - Missing cross-links to add
```

---

## Phase 4: Automatic Gap Filling

**Only runs if Phase 3 returns INCOMPLETE**

### Gap Filler Agent

```
GAP FILLER AGENT INSTRUCTIONS:

1. Read Gap Log from PROGRESS.md

2. For each gap:
   a. Identify the manifest file and item
   b. Read source code for that item
   c. Generate documentation
   d. Append to correct section in architecture file
   e. Update manifest: status:pending → status:documented
   f. Remove from Gap Log

3. After filling all gaps:
   a. Trigger Phase 3 (Verification) again
   b. This creates the self-healing loop

4. IMPORTANT: Track retry count
   - If same gap persists after 3 retries, mark as status:manual-review
   - Add to "Manual Review Required" section
```

---

## Phase 5: Final Validation & Cleanup

**Runs when Phase 3 returns COMPLETE**

### Final Validation Checklist

```
FINAL VALIDATION AGENT:

1. Structure Check:
   [ ] Table of Contents exists and is accurate
   [ ] All sections have content (no empty sections)
   [ ] Code examples are syntax-valid
   [ ] Internal links work

2. Completeness Check:
   [ ] All 15 manifest categories at 100%
   [ ] No items in Gap Log
   [ ] No items marked status:error without resolution

3. Quality Check:
   [ ] Each class has: description, location, key methods
   [ ] Each function has: purpose, parameters, return value
   [ ] Each hook has: type, parameters, usage example
   [ ] Each endpoint has: method, auth, schema

4. Generate Final Report:
   - Total items documented
   - Time taken
   - Categories with most items
   - Any items requiring manual review

5. Clean up:
   - Remove temporary manifest directory (optional)
   - Or keep for future updates
```

---

## Self-Progress Tracking

Throughout the entire process, maintain real-time progress:

### Progress Display Format

```
╔══════════════════════════════════════════════════════════════╗
║  CODEBASE ARCHITECT - Documentation Progress                 ║
╠══════════════════════════════════════════════════════════════╣
║  Plugin: <name>                                              ║
║  Started: <timestamp>                                        ║
║  Current Phase: <phase>                                      ║
║  Overall Coverage: ███████████░░░░░░░░░ 58%                  ║
╠══════════════════════════════════════════════════════════════╣
║  Category Progress:                                          ║
║  ├── Classes:      ████████████████████ 100% (45/45)        ║
║  ├── Functions:    ████████████████░░░░  82% (120/146)      ║
║  ├── Hooks:        ████████████░░░░░░░░  62% (89/143)       ║
║  ├── REST API:     ████████████████████ 100% (12/12)        ║
║  ├── AJAX:         ████████████████████ 100% (8/8)          ║
║  ├── JS Files:     ██████░░░░░░░░░░░░░░  30% (6/20)         ║
║  ├── DB Tables:    ████████████████████ 100% (5/5)          ║
║  ├── Templates:    ████████████░░░░░░░░  60% (30/50)        ║
║  └── ...                                                     ║
╠══════════════════════════════════════════════════════════════╣
║  Verification Runs: 2                                        ║
║  Gaps Remaining: 47                                          ║
║  Errors: 0                                                   ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Error Handling

### Recoverable Errors
- File not found → Mark status:error, continue
- Parse error → Mark status:error, log reason, continue
- Empty result → Mark status:empty, continue

### Non-Recoverable Errors
- Path doesn't exist → Abort with clear error
- No PHP files found → Abort with clear error
- Write permission denied → Abort with clear error

### Retry Logic
```
MAX_RETRIES = 3
RETRY_DELAY = 1 second

for each failed item:
  retry_count = 0
  while status != documented and retry_count < MAX_RETRIES:
    attempt_documentation()
    retry_count++

  if retry_count >= MAX_RETRIES:
    mark_for_manual_review()
```

---

## Output Files

```
<output-dir>/
├── PLUGIN_ARCHITECTURE.md      # Final documentation
├── manifest/
│   ├── PROGRESS.md             # Progress tracker
│   ├── classes.txt             # Class manifest
│   ├── functions.txt           # Function manifest
│   ├── hooks.txt               # Hooks manifest
│   ├── rest-endpoints.txt      # REST manifest
│   ├── ajax-handlers.txt       # AJAX manifest
│   ├── js-files.txt            # JS manifest
│   ├── db-tables.txt           # DB manifest
│   ├── templates.txt           # Templates manifest
│   ├── blocks.txt              # Blocks manifest
│   ├── shortcodes.txt          # Shortcodes manifest
│   ├── widgets.txt             # Widgets manifest
│   ├── cpt-taxonomies.txt      # CPT manifest
│   ├── admin-pages.txt         # Admin manifest
│   ├── cron-jobs.txt           # Cron manifest
│   └── cli-commands.txt        # CLI manifest
└── FINAL_REPORT.md             # Validation report
```

---

## Success Criteria

Documentation is COMPLETE when:

1. ✅ All 15 manifest files have 100% coverage (or documented exceptions)
2. ✅ Verification loop passes without finding new gaps
3. ✅ Cross-reference check passes
4. ✅ Final validation checklist complete
5. ✅ FINAL_REPORT.md generated with summary

---

## Usage Example

```bash
# Start documentation
/codebase-architect /wp-content/plugins/buddypress

# Monitor progress (runs automatically)
# Watch manifest/PROGRESS.md for real-time updates

# Final output
# → BUDDYPRESS_ARCHITECTURE.md (complete documentation)
# → manifest/ (audit trail)
# → FINAL_REPORT.md (summary)
```
