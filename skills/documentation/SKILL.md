---
name: documentation
description: Write clear technical documentation for themes, plugins, and web products including installation guides, configuration docs, API references, tutorials, and changelogs. Use when creating user guides, developer docs, or help articles.
---

# Documentation for WordPress Themes & Plugins

Comprehensive documentation that serves both end-users and developers, focusing on practical use cases and real-world scenarios.

## Documentation Philosophy

### The Two-Audience Approach

Every piece of documentation should consider:

| Audience | What They Need | How They Think |
|----------|---------------|----------------|
| **End Users** | "How do I accomplish X?" | Goal-oriented, non-technical |
| **Developers** | "How does this work technically?" | Code-oriented, wants hooks/APIs |

### The Use-Case First Principle

**BAD:** Feature-focused documentation
```markdown
## Image Gallery Settings
- Columns: 1-6
- Lightbox: Enable/Disable
- Animation: Fade, Slide, Zoom
```

**GOOD:** Use-case focused documentation
```markdown
## Creating an Image Gallery

### Use Case: Portfolio Showcase
Display your best work in a professional grid layout that opens
in a lightbox when clicked.

**Perfect for:** Photographers, designers, artists, agencies

**Steps:**
1. Add the Gallery block to your page
2. Upload or select your images
3. Choose "3 columns" for a balanced look
4. Enable "Lightbox" so visitors can view full-size images

**Pro tip:** For photography portfolios, use 2 columns to give
each image more visual weight.

### Use Case: Product Showcase (WooCommerce)
Show product variations or multiple angles...
```

## Documentation Structure

### 1. Getting Started Guide

Not just installation - help users achieve their first win quickly.

```markdown
# Getting Started with [Theme/Plugin Name]

## What You Can Do With [Product]

Before diving in, here's what [Product] helps you accomplish:

- ✅ **[Outcome 1]** — e.g., "Create a professional business website in under an hour"
- ✅ **[Outcome 2]** — e.g., "Accept bookings and appointments directly on your site"
- ✅ **[Outcome 3]** — e.g., "Showcase your portfolio with stunning galleries"

## Quick Start: Your First [Outcome] in 5 Minutes

Let's get you set up with [most common use case] right away.

### Step 1: Install and Activate
[Standard installation steps]

### Step 2: Run the Setup Wizard
After activation, you'll see a setup wizard. Choose:
- **Your industry:** This loads relevant demo content
- **Your color scheme:** Match your brand
- **Essential pages:** We'll create Home, About, Contact for you

### Step 3: Add Your Logo and Brand Colors
Go to **Appearance → Customize → Site Identity**
- Upload your logo (recommended: 200x60px PNG)
- Set your primary brand color

### Step 4: You're Live! 🎉
Visit your site to see the transformation.

## What's Next?

Based on what you want to achieve:

| I want to... | Go to... |
|--------------|----------|
| Customize my homepage | [Homepage Builder Guide](#) |
| Add a contact form | [Contact Forms Guide](#) |
| Set up my blog | [Blog Setup Guide](#) |
| Start selling products | [WooCommerce Integration](#) |
| Create a portfolio | [Portfolio Setup Guide](#) |
```

### 2. Feature Documentation Template

Structure features around problems and solutions.

```markdown
# [Feature Name]

## What This Does

[One sentence explaining the outcome, not the mechanism]

**Example:**
- ❌ "Enables conditional logic for form fields"
- ✅ "Show or hide form fields based on user answers, creating shorter, smarter forms"

## Who This Is For

- **Scenario 1:** [User type] who needs to [accomplish goal]
- **Scenario 2:** [User type] who wants to [achieve outcome]

**Examples:**
- Service businesses who need different fields for different service types
- Event organizers who collect different info based on ticket type
- Consultants who want to pre-qualify leads before booking calls

## Common Use Cases

### Use Case 1: [Descriptive Name]

**The Situation:**
[Describe the real-world scenario]

**The Solution:**
[Step-by-step how to set it up]

**The Result:**
[What the user achieves]

### Use Case 2: [Descriptive Name]
[Same structure]

## How to Set It Up

### Basic Setup

1. [Step with screenshot]
2. [Step with screenshot]
3. [Step with screenshot]

### Advanced Options

| Option | What It Does | When to Use |
|--------|--------------|-------------|
| [Option 1] | [Plain English explanation] | [Practical scenario] |
| [Option 2] | [Plain English explanation] | [Practical scenario] |

## Real-World Examples

### Example 1: [Industry/Niche] Website

**Goal:** [What they wanted to achieve]

**Setup:**
- [Setting 1]: [Value]
- [Setting 2]: [Value]

**Result:** [Outcome with specifics if possible]

### Example 2: [Different Industry]
[Same structure]

## Tips & Best Practices

💡 **Do:** [Positive recommendation]
💡 **Do:** [Another recommendation]
⚠️ **Avoid:** [Common mistake and why]

## Troubleshooting

### [Common Issue 1]
**Symptom:** [What user sees]
**Cause:** [Why it happens]
**Fix:** [How to resolve]

### [Common Issue 2]
[Same structure]

## Related Features

- [Related Feature 1] — [How it connects]
- [Related Feature 2] — [How it connects]
```

### 3. Use Case Library

Create a dedicated section for use cases organized by goal.

```markdown
# Use Case Library

## By Industry

### For Photographers
- [Creating a portfolio gallery](#)
- [Selling prints online](#)
- [Client proofing galleries](#)
- [Password-protected client areas](#)

### For Restaurants
- [Displaying your menu](#)
- [Taking online reservations](#)
- [Showing business hours](#)
- [Integrating with delivery apps](#)

### For Coaches & Consultants
- [Setting up a booking system](#)
- [Creating a resources library](#)
- [Building an email list](#)
- [Selling online courses](#)

### For Local Businesses
- [Google Maps integration](#)
- [Customer testimonials](#)
- [Service area pages](#)
- [Contact forms that convert](#)

## By Goal

### "I want to get more leads"
- [High-converting contact forms](#)
- [Exit-intent popups](#)
- [Lead magnets and downloads](#)
- [Live chat integration](#)

### "I want to sell products"
- [WooCommerce quick setup](#)
- [Product page optimization](#)
- [Cart and checkout customization](#)
- [Payment gateway setup](#)

### "I want to look professional"
- [Choosing the right layout](#)
- [Typography best practices](#)
- [Color scheme selection](#)
- [Mobile optimization](#)

### "I want to save time"
- [Template library usage](#)
- [Global styles and settings](#)
- [Reusable blocks](#)
- [Import/export settings](#)
```

### 4. Tutorial Format

Step-by-step guides for specific outcomes.

```markdown
# Tutorial: [Specific Outcome]

**Time needed:** ~[X] minutes
**Skill level:** Beginner / Intermediate / Advanced
**What you'll need:** [Prerequisites]

## What We're Building

[Screenshot or description of the end result]

By the end of this tutorial, you'll have:
- ✅ [Outcome 1]
- ✅ [Outcome 2]
- ✅ [Outcome 3]

## Before You Start

Make sure you have:
- [ ] [Prerequisite 1]
- [ ] [Prerequisite 2]
- [ ] [Prerequisite 3 - with link to guide if needed]

## Step 1: [Action]

[Explanation of what we're doing and why]

1. Navigate to **[Location]**
2. Click **[Button/Link]**
3. [Specific action]

![Screenshot with annotations](screenshot.png)

**What you should see:** [Description of expected result]

> 💡 **Tip:** [Helpful context or shortcut]

## Step 2: [Action]

[Same structure]

## Step 3: [Action]

[Same structure]

## Final Result

[Screenshot of completed outcome]

You've successfully [achieved outcome]!

## Taking It Further

Now that you have the basics, you might want to:
- [Advanced variation 1](#)
- [Related feature to explore](#)
- [Optimization tips](#)

## Troubleshooting

**Something not working?** Check these common issues:

| Problem | Solution |
|---------|----------|
| [Issue 1] | [Fix] |
| [Issue 2] | [Fix] |

Still stuck? [Contact support](#) with error details.
```

## End-User Documentation

### Writing for Non-Technical Users

#### Language Guidelines

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

#### Explaining Technical Concepts

```markdown
## Caching (Making Your Site Faster)

**What it is:** Caching saves a copy of your pages so they load
instantly for visitors, instead of being rebuilt each time.

**Think of it like:** A restaurant that pre-makes popular dishes
during slow hours, so they're ready immediately when ordered.

**Why you want it:** Your site loads faster, visitors stay longer,
and Google ranks you higher.

**How to enable it:**
1. Go to **Settings → Performance**
2. Turn on "Enable Page Caching"
3. That's it! Your site is now faster.
```

### Common Page Types Documentation

```markdown
# Setting Up Your [Page Type]

## Homepage

### What Makes a Good Homepage
Your homepage should answer three questions in 5 seconds:
1. **What do you do?** (Clear headline)
2. **Who is it for?** (Target audience)
3. **What should I do next?** (Call to action)

### Recommended Layout for [Industry]

**Hero Section:**
- Headline: [Template based on industry]
- Subheadline: [Supporting statement]
- CTA Button: [Recommended text]
- Background: [Image recommendations]

**Trust Section:**
- Client logos or testimonials
- "As seen in" or certifications

**Services/Features Section:**
- 3-4 key offerings with icons
- Brief descriptions (2 lines max)
- Link to learn more

**About Preview:**
- Brief intro to build connection
- Photo of you/team
- Link to full About page

**Final CTA:**
- Repeat main call to action
- Contact form or booking button

### Step-by-Step Setup
[Detailed steps with screenshots]
```

### Comparison Documentation

Help users choose between options.

```markdown
# Header Styles: Which One Is Right for You?

## Quick Comparison

| Style | Best For | Example Sites |
|-------|----------|---------------|
| **Classic** | Professional services, law firms, consultants | [Demo](#) |
| **Centered** | Portfolios, personal brands, creatives | [Demo](#) |
| **Transparent** | Photography, real estate, luxury brands | [Demo](#) |
| **Sticky** | E-commerce, content-heavy sites | [Demo](#) |

## Detailed Breakdown

### Classic Header
![Screenshot](classic-header.png)

**Characteristics:**
- Logo on left, menu on right
- Clean, traditional look
- Works with any content below

**Choose this if:**
- ✅ You want a professional, timeless look
- ✅ You have a wide logo
- ✅ Your audience expects traditional navigation

**Avoid if:**
- ❌ You want to stand out with unique design
- ❌ Your site is very visual/creative

**How to enable:**
Appearance → Customize → Header → Style → Classic

### Centered Header
[Same structure for each option]
```

## Developer Documentation

### API Reference Structure

```markdown
# Developer Reference

## Hooks & Filters

### Actions

#### `theme_name_before_header`
Fires before the header is rendered.

**When to use:** Add content above the header (announcements,
top bar, promotional banners).

**Parameters:** None

**Example:**
```php
add_action( 'theme_name_before_header', function() {
    if ( is_front_page() ) {
        echo '<div class="promo-bar">Free shipping on orders over $50!</div>';
    }
});
```

**Related:**
- `theme_name_after_header` - After header
- `theme_name_header_content` - Inside header

---

#### `theme_name_after_footer`
[Same structure]

### Filters

#### `theme_name_logo_args`
Modify logo output arguments.

**When to use:** Change logo size, add attributes, or modify
logo HTML based on conditions.

**Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `$args` | array | Logo arguments |
| `$args['width']` | int | Logo width in pixels |
| `$args['height']` | int | Logo height in pixels |
| `$args['class']` | string | CSS classes |

**Return:** `array` Modified arguments

**Example - Different logo sizes by page:**
```php
add_filter( 'theme_name_logo_args', function( $args ) {
    if ( is_front_page() ) {
        $args['width'] = 300;
        $args['height'] = 100;
    }
    return $args;
});
```

**Example - Add custom class:**
```php
add_filter( 'theme_name_logo_args', function( $args ) {
    $args['class'] .= ' my-custom-logo-class';
    return $args;
});
```
```

### Code Snippets Library

```markdown
# Code Snippets

Ready-to-use code for common customizations. Add these to your
child theme's `functions.php` or a code snippets plugin.

## Header & Navigation

### Add a button to the navigation menu
```php
/**
 * Add a CTA button as the last menu item
 */
add_filter( 'wp_nav_menu_items', function( $items, $args ) {
    if ( $args->theme_location === 'primary' ) {
        $items .= '<li class="menu-item menu-cta">';
        $items .= '<a href="/contact" class="button">Get a Quote</a>';
        $items .= '</li>';
    }
    return $items;
}, 10, 2 );
```

### Show different logo for logged-in users
```php
add_filter( 'theme_name_logo_url', function( $logo_url ) {
    if ( is_user_logged_in() ) {
        return get_stylesheet_directory_uri() . '/images/member-logo.png';
    }
    return $logo_url;
});
```

## WooCommerce

### Change "Add to Cart" button text
```php
add_filter( 'woocommerce_product_single_add_to_cart_text', function() {
    return 'Buy Now';
});

add_filter( 'woocommerce_product_add_to_cart_text', function() {
    return 'Add to Bag';
});
```

### Add custom field to checkout
```php
add_filter( 'woocommerce_checkout_fields', function( $fields ) {
    $fields['billing']['billing_company_vat'] = array(
        'label'       => 'VAT Number',
        'placeholder' => 'Enter VAT number',
        'required'    => false,
        'priority'    => 35,
    );
    return $fields;
});
```

## Footer

### Add custom content before footer widgets
```php
add_action( 'theme_name_before_footer_widgets', function() {
    ?>
    <div class="newsletter-signup">
        <h3>Subscribe to Our Newsletter</h3>
        <?php echo do_shortcode( '[newsletter_form]' ); ?>
    </div>
    <?php
});
```

## Performance

### Defer non-critical JavaScript
```php
add_filter( 'script_loader_tag', function( $tag, $handle ) {
    $defer_scripts = array( 'theme-scripts', 'slider', 'popup' );

    if ( in_array( $handle, $defer_scripts ) ) {
        return str_replace( ' src', ' defer src', $tag );
    }

    return $tag;
}, 10, 2 );
```
```

### Extending/Customizing Guides

```markdown
# Customization Guide

## Method Comparison

| Method | Skill Level | Survives Updates | Best For |
|--------|-------------|------------------|----------|
| **Customizer** | Beginner | ✅ Yes | Colors, fonts, layout |
| **Custom CSS** | Beginner | ✅ Yes | Visual tweaks |
| **Child Theme** | Intermediate | ✅ Yes | Template changes |
| **Hooks/Filters** | Developer | ✅ Yes | Functionality |
| **Edit Theme Files** | Advanced | ❌ No | Never do this |

## Using Custom CSS

### Where to Add Custom CSS
**Appearance → Customize → Additional CSS**

### Common Customizations

#### Change button colors
```css
/* Primary buttons */
.button,
button[type="submit"],
.wp-block-button__link {
    background-color: #your-color;
    border-color: #your-color;
}

.button:hover {
    background-color: #darker-shade;
}
```

#### Hide an element
```css
/* Hide the post date */
.entry-date {
    display: none;
}
```

#### Adjust spacing
```css
/* Add more space between sections */
.section {
    padding-top: 80px;
    padding-bottom: 80px;
}
```

## Creating a Child Theme

### When You Need a Child Theme
- Modifying template files (PHP)
- Adding new template parts
- Overriding theme functions
- Major structural changes

### Quick Setup

1. Create folder: `wp-content/themes/theme-name-child/`

2. Create `style.css`:
```css
/*
Theme Name: Theme Name Child
Template: theme-name
*/
```

3. Create `functions.php`:
```php
<?php
add_action( 'wp_enqueue_scripts', function() {
    wp_enqueue_style( 'parent-style',
        get_template_directory_uri() . '/style.css'
    );
});
```

4. Activate child theme in WordPress

### Overriding Templates

Copy the template file from parent theme to child theme with
same folder structure:

```
Parent: themes/theme-name/template-parts/header.php
Child:  themes/theme-name-child/template-parts/header.php
```

The child theme version will be used automatically.
```

## Writing Guidelines

### The CUBI Framework

Every piece of documentation should be:

- **C**lear — Simple language, no jargon
- **U**seful — Solves a real problem
- **B**rowsable — Easy to scan, good headings
- **I**llustrated — Screenshots, examples, code

### Screenshot Best Practices

```markdown
## Taking Effective Screenshots

### Do:
- ✅ Annotate with arrows/highlights pointing to relevant areas
- ✅ Show context (what page, what section)
- ✅ Use consistent browser/window size
- ✅ Crop to relevant area (not full screen)
- ✅ Use numbered steps matching text

### Don't:
- ❌ Include personal data or real customer info
- ❌ Show unrelated browser tabs
- ❌ Use tiny text that's hard to read
- ❌ Skip screenshots for complex steps

### Annotation Style Guide
- **Red boxes/circles:** "Click here" or "Look here"
- **Numbered badges:** Step sequences
- **Arrows:** Flow or direction
- **Blur:** Sensitive information
```

### Writing Checklist

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
- [ ] Important notes are highlighted (tips, warnings)

**Usability:**
- [ ] Tested by someone unfamiliar with feature
- [ ] Steps actually work as described
- [ ] Screenshots match current UI
- [ ] Links work correctly

## Changelog Format

```markdown
## Changelog

### 2.5.0 - January 15, 2025

#### ✨ New Features
- **Mega Menu Support** — Create rich dropdown menus with
  images, icons, and multiple columns. Perfect for sites
  with many categories. [Learn how →](#)

- **Dark Mode Toggle** — Let visitors switch between light
  and dark themes. Works automatically with your color scheme.

#### 🔧 Improvements
- **Faster Page Loading** — Optimized image loading reduces
  page load time by up to 40%
- **Better Mobile Menu** — Smoother animations and larger
  touch targets on mobile devices
- **WooCommerce 8.5 Compatibility** — Tested and ready for
  the latest WooCommerce

#### 🐛 Bug Fixes
- Fixed: Logo not displaying correctly on Safari 17
- Fixed: Footer widgets not aligning properly on tablets
- Fixed: Search form styling inconsistent with theme

#### ⚠️ Notes
- Requires WordPress 6.4 or higher (was 6.2)
- PHP 8.0+ now required for full functionality
- [Breaking change if any, with migration guide]

---

### 2.4.3 - December 20, 2024
[Previous version]
```

## FAQ Best Practices

### Organize by User Journey

```markdown
## Frequently Asked Questions

### Getting Started

**I just installed the theme. What should I do first?**
Run the Setup Wizard! Go to **Appearance → Theme Setup** and
follow the guided steps. In about 5 minutes, you'll have a
beautiful site ready to customize. [Full setup guide →](#)

**How do I import the demo content?**
[Answer with steps]

### Customization

**How do I change my site colors?**
[Answer]

**Can I use my own fonts?**
[Answer]

### Troubleshooting

**My site looks different from the demo**
This usually happens when you haven't imported the demo
content or installed required plugins. Here's how to fix it:
1. [Step]
2. [Step]

**Something broke after I made changes**
[Answer with reassurance and steps]

### Purchasing & Licenses

**Can I use this on multiple sites?**
[Answer based on license type]

**How do I get updates?**
[Answer]
```

### Answer Framework

```markdown
**[Question exactly as user would ask it?]**

[Direct answer in first sentence]

[Supporting details or steps if needed]

[Link to more info if complex topic]
```

## Video Documentation Scripts

### Script Template

```markdown
# Video: [Topic]

**Duration:** [X] minutes
**Type:** Tutorial / Overview / Walkthrough

## Hook (0:00 - 0:15)
[Attention-grabbing opening - problem or outcome]

"Ever wished you could [desired outcome]? In the next [X]
minutes, I'll show you exactly how."

## Intro (0:15 - 0:30)
[Brief overview of what we'll cover]

"We'll cover:
- [Point 1]
- [Point 2]
- [Point 3]"

## Main Content (0:30 - [X]:00)

### Section 1: [Topic]
[Script with on-screen actions noted]

**On screen:** Navigate to Settings → General
**Voiceover:** "First, head to your settings panel..."

### Section 2: [Topic]
[Continue pattern]

## Recap ([X]:00 - [X]:30)
[Quick summary of key points]

"So to recap:
- [Key point 1]
- [Key point 2]
- [Key point 3]"

## CTA ([X]:30 - End)
[What to do next]

"If this helped, check out [related video/guide]. And if you
have questions, drop them in the comments below."
```

## Documentation Maintenance

### Version-Specific Documentation

```markdown
<!-- Version notice component -->
> 📌 **Version Notice:** This guide is for Theme Name 2.5+.
> Using an older version? [See the 2.4 documentation](#).

<!-- Feature availability -->
> ✨ **Pro Feature:** This feature requires Theme Name Pro.
> [Compare versions →](#)

<!-- Deprecated notice -->
> ⚠️ **Deprecated in 2.5:** This method still works but is
> no longer recommended. [See the new approach →](#)
```

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
