---
name: documentation
description: Write clear technical documentation for themes, plugins, and web products including installation guides, configuration docs, API references, tutorials, and changelogs. Use when creating user guides, developer docs, or help articles.
---

# Documentation Skill for Theme & Plugin Agency

## Instructions

When writing documentation:

### 1. Installation Guides

```markdown
## Installation

### Requirements
- WordPress 6.0+
- PHP 8.0+
- [Other requirements]

### Method 1: WordPress Dashboard
1. Go to **Plugins → Add New**
2. Click **Upload Plugin**
3. Choose the `.zip` file
4. Click **Install Now**
5. Click **Activate**

### Method 2: FTP Upload
1. Extract the `.zip` file
2. Upload to `/wp-content/plugins/`
3. Activate in WordPress dashboard
```

### 2. Configuration Documentation

**Structure:**
- Overview of settings
- Screenshots with annotations
- Default values noted
- Common configurations
- Troubleshooting tips

**Format:**
```markdown
## Settings

### General Tab

#### Site Logo
- **Location:** Appearance → Theme Options → General
- **Type:** Image upload
- **Recommended size:** 200x50px
- **Formats:** PNG, SVG (recommended)

> **Tip:** Use SVG for crisp display on retina screens.
```

### 3. API/Developer Documentation

```markdown
## Hooks & Filters

### theme_header_logo
Modify the logo output.

**Parameters:**
| Name | Type | Description |
|------|------|-------------|
| `$logo` | string | Logo HTML |
| `$args` | array | Logo arguments |

**Example:**
\`\`\`php
add_filter('theme_header_logo', function($logo, $args) {
    return '<div class="custom-logo">' . $logo . '</div>';
}, 10, 2);
\`\`\`
```

### 4. Tutorials & How-To Guides

**Structure:**
1. What you'll learn (outcome)
2. Prerequisites
3. Step-by-step instructions
4. Screenshots/code examples
5. Expected result
6. Troubleshooting
7. Next steps

### 5. Changelog Format

```markdown
## Changelog

### 2.5.0 - 2025-01-15

#### Added
- New header layout options
- WooCommerce 8.0 compatibility

#### Changed
- Improved mobile menu performance
- Updated translation files

#### Fixed
- Logo not displaying on Safari
- Footer widget alignment issue

#### Deprecated
- Legacy shortcode [old_gallery] (use [gallery] instead)
```

### 6. FAQ Documentation

```markdown
## Frequently Asked Questions

### How do I update the theme?
1. Backup your site
2. Go to **Appearance → Themes**
3. Click **Update** on the theme

> **Note:** Custom changes to theme files will be lost. Use a child theme.

### Why is [feature] not working?
Common causes:
- Plugin conflict (test with plugins disabled)
- Caching issue (clear cache)
- Outdated version (update to latest)
```

### Writing Guidelines

1. **Use simple language** — No jargon unless necessary
2. **Be scannable** — Headers, bullets, short paragraphs
3. **Show, don't just tell** — Include screenshots & code
4. **Anticipate questions** — Add notes and tips
5. **Keep updated** — Version-specific docs
6. **Include search terms** — Users search differently
