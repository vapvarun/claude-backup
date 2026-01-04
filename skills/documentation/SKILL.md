---
name: documentation
description: Write clear technical documentation for themes, plugins, and web products including installation guides, configuration docs, API references, tutorials, and changelogs. Use when creating user guides, developer docs, or help articles.
---

# Documentation for WordPress Themes & Plugins

Comprehensive documentation that serves both end-users and developers, focusing on practical use cases and real-world scenarios.

## Writing Tone Guidelines

### Human, Not AI

Write as a knowledgeable colleague would explain things. Not as a marketing bot or formal manual.

**Avoid:**
- Excessive emojis (limit to one per section maximum, only when it adds clarity)
- Marketing buzzwords ("revolutionary", "game-changing", "seamless", "powerful")
- Filler words ("basically", "essentially", "simply", "just")
- Overly enthusiastic language ("Amazing!", "You'll love this!")
- Robotic phrasing ("In order to", "It should be noted that")

**Use instead:**
- Direct, clear language
- Active voice
- Specific details over vague claims
- Conversational but professional tone
- Real examples from actual use cases

### Good vs Bad Examples

**Bad:** "This amazing feature will revolutionize how you create stunning galleries! Simply click the magical button and watch your dreams come true!"

**Good:** "The gallery block lets you display images in a grid. Click Add Gallery, select your images, and choose how many columns you want. Three columns works well for portfolios."

### Screenshot Requirements

All documentation must include real screenshots:
- Use a clean local WordPress installation
- Use realistic sample data (not "Test Post 1", "Lorem ipsum")
- Annotate with arrows or highlights to show where to click
- Crop to the relevant area only
- Ensure no sensitive data is visible
- Keep consistent browser/window size across all screenshots
- Update screenshots when UI changes

## Documentation Philosophy

### The Two-Audience Approach

Every piece of documentation should consider:

| Audience | What They Need | How They Think |
|----------|---------------|----------------|
| **End Users** | "How do I accomplish X?" | Goal-oriented, non-technical |
| **Developers** | "How does this work technically?" | Code-oriented, wants hooks/APIs |

### The Use-Case First Principle

**BAD:** Feature-focused documentation
\`\`\`markdown
## Image Gallery Settings
- Columns: 1-6
- Lightbox: Enable/Disable
- Animation: Fade, Slide, Zoom
\`\`\`

**GOOD:** Use-case focused documentation
\`\`\`markdown
## Creating an Image Gallery

### Use Case: Portfolio Showcase
Display your best work in a professional grid layout that opens in a lightbox when clicked.

**Perfect for:** Photographers, designers, artists, agencies

**Steps:**
1. Add the Gallery block to your page
2. Upload or select your images
3. Choose "3 columns" for a balanced look
4. Enable "Lightbox" so visitors can view full-size images

**Tip:** For photography portfolios, use 2 columns to give each image more visual weight.
\`\`\`

## Writing Guidelines

### The CUBI Framework

Every piece of documentation should be:

- **C**lear - Simple language, no jargon
- **U**seful - Solves a real problem
- **B**rowsable - Easy to scan, good headings
- **I**llustrated - Screenshots, examples, code

### Language Guidelines

| Avoid | Use Instead |
|-------|-------------|
| "Configure the parameters" | "Adjust the settings" |
| "Execute the function" | "Click the button" |
| "API endpoint" | "Connection" |
| "Deprecated" | "Older version (not recommended)" |
| "Parse the data" | "Read the information" |
| "Instantiate" | "Create" or "Set up" |
| "Callback" | "What happens next" |
| "Render" | "Display" or "Show" |

### Screenshot Best Practices

**Do:**
- Annotate with arrows/highlights pointing to relevant areas
- Show context (what page, what section)
- Use consistent browser/window size
- Crop to relevant area (not full screen)
- Use numbered steps matching text

**Don't:**
- Include personal data or real customer info
- Show unrelated browser tabs
- Use tiny text that's hard to read
- Skip screenshots for complex steps

### Annotation Style Guide
- **Red boxes/circles:** "Click here" or "Look here"
- **Numbered badges:** Step sequences
- **Arrows:** Flow or direction
- **Blur:** Sensitive information

## Writing Checklist

Before publishing documentation:

**Content:**
- [ ] Explains the "why" not just the "how"
- [ ] Includes real-world use cases
- [ ] Covers both simple and advanced scenarios
- [ ] Has troubleshooting for common issues
- [ ] Links to related features

**Clarity:**
- [ ] Uses simple, non-technical language
- [ ] Defines jargon when necessary
- [ ] Steps are numbered and clear
- [ ] Each step is one action only

**Formatting:**
- [ ] Has clear headings and subheadings
- [ ] Uses bullet points for lists
- [ ] Includes screenshots for complex steps
- [ ] Code examples are properly formatted

**Usability:**
- [ ] Tested by someone unfamiliar with feature
- [ ] Steps actually work as described
- [ ] Screenshots match current UI
- [ ] Links work correctly

## WordPress Screenshot Automation

### Prerequisites

Before capturing screenshots, install the auto-login mu-plugin on your local WordPress site:

```bash
# Copy the mu-plugin to your WordPress installation
cp ~/.claude/skills/documentation/templates/mu-auto-login.php \
   /path/to/wp-content/mu-plugins/dev-auto-login.php
```

This mu-plugin allows auto-login via URL parameter (`?dev_login=USER_ID`) without storing passwords. It only works on local development domains (.local, .test, localhost).

### Screenshot Capture Script

For WordPress projects, use the automated screenshot capture system instead of manual screenshots.

**Location:** `docs/tools/capture-screenshots.py` (per-project)

**Setup:**
```bash
pip install playwright
playwright install chromium
```

**Standard viewport:** 1680x1100 (captures full admin tabs without cut-off)

### Role-Based Captures

Always capture documentation from the perspective of the target user:

| Audience | Login As | What to Capture |
|----------|----------|-----------------|
| Site Admins | admin | Admin settings, configuration pages |
| Content Creators | author/contributor | Post creation, editing, dashboard |
| Members | subscriber | Frontend profile, public views |

### Screenshot Config Template

Create `docs/tools/captures.yaml` for each project:

```yaml
# Site configuration
site:
  url: "http://your-site.local"
  viewport: { width: 1680, height: 1100 }

# User roles for testing (NO passwords - uses mu-plugin auto-login!)
roles:
  admin:
    user_id: 1  # Login via ?dev_login=1
    username: "admin_user"  # For URL placeholders like /members/{username}/
  subscriber:
    user_id: 2  # Login via ?dev_login=2
    username: "test_member"

# Screenshot definitions
captures:
  admin_settings:
    role: admin
    items:
      - navigate: "/wp-admin/admin.php?page=plugin-settings"
        filename: "admin-settings.png"
        description: "Main settings page"

  frontend_member:
    role: subscriber
    items:
      - navigate: "/members/{username}/"
        filename: "member-profile.png"
        full_page: true
```

### Common WordPress Selectors

Plugin tabs (Wbcom style):
```css
.nav-tab-wrapper li#{tab_id} a.nav-tab
```

WordPress admin menu:
```css
#adminmenu a[href*="page=plugin-slug"]
```

BuddyPress profile tabs:
```css
#subnav a[href*="/blog/"]
```

### When to Re-capture Screenshots

- **Always**: After UI changes in a release
- **Always**: After changing viewport size
- **Sometimes**: When adding new documentation sections
- **Never**: For minor text-only changes

## Screenshot Annotation with Image Annotator MCP

The capture script automatically extracts element positions and saves annotation metadata. Use the Image Annotator MCP to create professional annotated screenshots.

### Complete Workflow

```
1. Run capture script → Plain screenshots + JSON metadata
2. Ask Claude to annotate → Uses metadata with Image Annotator MCP
3. Output: Plain (docs/images/) + Annotated (docs/images/annotated/)
4. Use annotated versions in documentation
```

### Defining Annotations in Capture Script

Add `annotations` array to any capture definition:

```python
ADMIN_TABS = [
    {
        "tab": "general",
        "filename": "admin-general-tab.png",
        "annotations": [
            # Numbered markers for step sequences
            {"selector": "#enable_blog", "label": "Enable blogging", "type": "number", "number": 1},
            {"selector": "#post_limit", "label": "Set post limit", "type": "number", "number": 2},
            {"selector": "input[type='submit']", "label": "Save", "type": "number", "number": 3},

            # Arrows pointing to elements
            {"selector": ".nav-tab-wrapper", "label": "Settings Tabs", "type": "arrow", "position": "top"},

            # Boxes around areas
            {"selector": ".form-table", "label": "Configuration Options", "type": "box", "position": "right"},

            # Circles for emphasis
            {"selector": ".premium-badge", "label": "Pro Feature", "type": "circle"},

            # Highlights (semi-transparent overlay)
            {"selector": "#important-section", "type": "highlight"},
        ]
    },
]
```

### Annotation Types

| Type | Use For | Example |
|------|---------|---------|
| `number` | Step sequences | "1. Click here, 2. Fill this, 3. Save" |
| `arrow` | Pointing to elements | "← Click this button" |
| `box` | Highlighting areas | Box around a form section |
| `circle` | Single element emphasis | Circle around a checkbox |
| `callout` | Speech bubbles | "Important: Enable this first!" |
| `highlight` | Semi-transparent overlay | Dim everything except focus area |

### Annotating After Capture

After running the capture script, ask Claude to annotate:

```
"Annotate the screenshot docs/images/admin-general-tab.png using the metadata
in docs/images/metadata/admin-general-tab.json"
```

Claude will use the Image Annotator MCP tools:
- `annotate_screenshot` - Full annotation with markers, arrows, callouts
- `create_step_guide` - Numbered steps with connecting arrows
- `highlight_area` - Quick area highlighting
- `add_callout` - Speech bubble callouts
- `blur_area` - Blur sensitive information

### Output Structure

```
docs/images/
├── admin-general-tab.png          # Plain screenshot
└── annotated/
    └── admin-general-tab.png      # Annotated version (final)

/tmp/screenshot-metadata/          # TEMPORARY - auto-cleaned after annotation
├── admin-general-tab.json         # Element positions
└── admin-general-tab_prompt.txt   # Ready-to-use prompt
```

**Note:** Metadata is stored in `/tmp/` and cleaned up after annotation is complete.

### Using in Documentation

Reference annotated screenshots in your docs:

```markdown
## General Settings

![General Settings](images/annotated/admin-general-tab.png)

1. **Enable Blogging** - Turn on member blog functionality
2. **Post Limit** - Maximum posts per member (0 = unlimited)
3. **Save Changes** - Don't forget to save!
```

### Image Annotator MCP Tools Reference

```javascript
// Full annotation
annotate_screenshot({
  input_path: "docs/images/screenshot.png",
  output_path: "docs/images/annotated/screenshot.png",
  annotations: [
    {type: "marker", x: 100, y: 100, number: 1, color: "primary"},
    {type: "arrow", from: [130, 100], to: [200, 150], color: "red"},
    {type: "callout", x: 300, y: 200, text: "Click here!", pointer: "left"},
    {type: "rect", x: 50, y: 250, width: 200, height: 100, color: "green"},
  ],
  theme: "documentation"  // or: tutorial, bugReport, highlight
})

// Quick step guide
create_step_guide({
  input_path: "docs/images/screenshot.png",
  output_path: "docs/images/annotated/screenshot.png",
  steps: [
    {x: 100, y: 100, label: "Click Settings"},
    {x: 200, y: 200, label: "Enable feature"},
    {x: 300, y: 300, label: "Save changes"},
  ]
})
```

## Video Tutorial Creation

### Video Workflow

For step-by-step tutorials, create video guides with subtitles.

**Output formats:**
- MP4 for tutorials (YouTube, help docs)
- GIF for quick demos (README, inline docs)

### Video Step Template

```yaml
video:
  title: "How to Create a Blog Post"
  role: subscriber
  output: "videos/create-post.mp4"
  srt: "videos/create-post.srt"
  steps:
    - action: navigate
      url: "/my-dashboard/"
      narration: "Go to your blog dashboard."
      duration: 3

    - action: click
      selector: ".add-new-btn"
      narration: "Click Add New Post."
      duration: 2
      highlight: true

    - action: type
      selector: "#post-title"
      text: "My First Post"
      narration: "Enter your post title."
      duration: 3
```

### SRT File Format

Auto-generate from video steps:

```srt
1
00:00:00,000 --> 00:00:03,000
Go to your blog dashboard.

2
00:00:03,000 --> 00:00:05,000
Click Add New Post.

3
00:00:05,000 --> 00:00:08,000
Enter your post title.
```

### Video Best Practices

- **Duration:** 1-3 minutes for single tasks
- **Speed:** Normal typing speed, no rushing
- **Highlight:** Circle or arrow on click targets
- **Pause:** 1-2 seconds after each action for viewer to follow
- **Audio:** Generate voiceover from narration text or keep silent with subtitles

## Documentation Maintenance

### Regular Review Checklist

**Monthly:**
- [ ] Check for broken links
- [ ] Update screenshots if UI changed
- [ ] Review support tickets for documentation gaps
- [ ] Update FAQs with new common questions

**With Each Release:**
- [ ] Document new features
- [ ] Update changed features
- [ ] Add version notices where needed
- [ ] Update compatibility information
- [ ] Review and update related docs
- [ ] Re-run screenshot capture script
- [ ] Update video tutorials if flow changed

### Screenshot Refresh Workflow

```bash
# 1. Update capture script if new tabs/pages added
# 2. Define annotations for important elements
# 3. Run capture script
python3 docs/tools/capture-screenshots.py

# 4. Review plain screenshots in docs/images/
# 5. Ask Claude: "Annotate screenshots using /tmp/screenshot-metadata/"
# 6. Claude annotates + cleans up temp metadata automatically
# 7. Review annotated versions in docs/images/annotated/
# 8. Update docs to reference annotated images
# 9. Commit and push (only docs/images/ - no temp files)
```

---

## Skill Resources

This skill includes reusable configs and templates in the skill directory.

### Location
```
~/.claude/skills/documentation/
├── skill.md              # This file
├── configs/
│   ├── sites.yaml        # WordPress sites registry (all your dev sites)
│   └── roles.yaml        # User roles with IDs (no passwords!)
└── templates/
    ├── mu-auto-login.php        # MU-plugin for auto-login (install first!)
    └── capture-screenshots.py   # Screenshot capture script template
```

### sites.yaml - Site Registry

Global configuration for all WordPress development sites:

```yaml
sites:
  member-blog-local:
    url: "http://member-blog.local"
    admin_path: "/wp-admin"
    plugin_path: "/path/to/wp-content/plugins"

  flavor-theme:
    url: "http://flavor-theme.local"

default: member-blog-local

viewport:
  width: 1680
  height: 1100
```

**To add a new site:** Edit `~/.claude/skills/documentation/configs/sites.yaml`

### roles.yaml - User Roles

User roles with IDs for all WordPress sites (NO passwords - uses mu-plugin!):

```yaml
# User roles - use user IDs, not passwords
roles:
  admin:
    user_id: 1  # Login via ?dev_login=1
    username: "admin"
    description: "Full admin access"

  subscriber:
    user_id: 2
    username: "test_member"
    description: "Basic member access"

member_types:
  premium:
    user_id: 10
    username: "premium_member"
    bp_member_type: "premium"
```

**Note:** User IDs are site-specific. Update for each project.

**To add roles:** Edit `~/.claude/skills/documentation/configs/roles.yaml`

### Setting Up a New Project

1. **Install the auto-login mu-plugin (one-time per site):**
   ```bash
   cp ~/.claude/skills/documentation/templates/mu-auto-login.php \
      /path/to/wp-content/mu-plugins/dev-auto-login.php
   ```

2. **Copy the template script:**
   ```bash
   cp ~/.claude/skills/documentation/templates/capture-screenshots.py \
      your-plugin/docs/tools/capture-screenshots.py
   ```

3. **Customize for your project:**
   - Update `SITE_CONFIG` with your site URL and plugin slug
   - Update `ROLES` with actual user IDs from your WordPress site
   - Define `ADMIN_TABS` for your plugin's settings tabs
   - Define `FRONTEND_PAGES` for member-facing pages
   - Add `EDITOR_TYPES` if your plugin has multiple editors

4. **Get user IDs from WordPress:**
   ```bash
   # Via WP-CLI
   wp user list --fields=ID,user_login,roles

   # Or check: /wp-admin/users.php (hover over user to see ID)
   ```

5. **Run the capture:**
   ```bash
   python3 docs/tools/capture-screenshots.py
   ```

### Quick Commands

```bash
# Install dependencies (one-time)
pip install playwright pyyaml pillow
playwright install chromium

# Run capture script (captures + extracts annotation metadata to /tmp/)
python3 docs/tools/capture-screenshots.py

# View captured screenshots
open docs/images/

# View temp annotation metadata
cat /tmp/screenshot-metadata/*.json
```

### Annotation Workflow

After capture, tell Claude:

```
"Using the Image Annotator MCP, annotate all screenshots with metadata
in /tmp/screenshot-metadata/. Save to docs/images/annotated/.
After annotation is complete, clean up the temp metadata."
```

Claude will:
1. Read metadata from `/tmp/screenshot-metadata/*.json`
2. Annotate each screenshot using Image Annotator MCP
3. Save annotated versions to `docs/images/annotated/`
4. Delete `/tmp/screenshot-metadata/` when done

---

## Troubleshooting

### Screenshots Cut Off
- Increase viewport: `VIEWPORT = {"width": 1920, "height": 1200}`
- Use `full_page=True` for scrollable content

### Login Fails
- Verify mu-plugin is installed: `ls wp-content/mu-plugins/dev-auto-login.php`
- Check user ID exists: `wp user get USER_ID`
- Ensure site is on local domain (.local, .test, localhost)
- Check browser console for redirect loops
- Disable 2FA/security plugins on test site

### Tabs Not Clicking
- Inspect HTML for correct tab ID
- Update selector pattern in script
- Add longer wait times

### Form Not Rendering Properly
- Use `headless=False` for JavaScript-heavy forms
- Increase `WAIT_TIME` after navigation
- Check browser console for errors

### Script Errors
```bash
# Debug mode - run with visible browser
HEADLESS = False

# Check Python version (requires 3.7+)
python3 --version

# Reinstall Playwright if needed
pip install --upgrade playwright
playwright install chromium
```

### Testing Auto-Login Manually

Before running the capture script, test the mu-plugin in your browser:

```
# Login as admin (user ID 1)
http://your-site.local/wp-admin/?dev_login=1

# Login as specific user (user ID 5)
http://your-site.local/wp-admin/?dev_login=5

# Login by username
http://your-site.local/wp-admin/?dev_login=test_subscriber

# Login and redirect to specific page
http://your-site.local/?dev_login=5&redirect=/members/test_member/blog/
```

If auto-login works in browser but not in script, check:
- Playwright is using the correct site URL
- No cookie/session issues (clear SESSION_DIR)
