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
