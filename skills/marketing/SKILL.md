---
name: marketing
description: Create comprehensive marketing content for themes, plugins, and web products. Generates organized folder structure with product descriptions, feature highlights, social media posts, email campaigns, video scripts, sales materials, and brand assets. Use when creating promotional content, announcements, or sales copy.
---

# Marketing Skill for Theme & Plugin Agency

## Folder Structure

When creating marketing content for a product, create this folder structure:

```
marketing/
├── 01-slides/                    # Visual presentation content
│   ├── product-overview-slides.md
│   ├── feature-breakdown-slides.md
│   ├── use-case-slides.md
│   └── free-vs-pro-comparison.md
├── 02-video-scripts/             # Video content
│   ├── 01-product-overview.md    # 2-3 min explainer
│   ├── 02-installation-setup.md  # Tutorial
│   ├── 03-feature-demos.md       # Feature walkthroughs
│   ├── short-ads.md              # 15s, 30s, 60s scripts
│   └── shot-list-template.md     # Production notes
├── 03-website-copy/              # Website content
│   ├── landing-page.md           # Full landing page
│   ├── features.md               # Feature highlights
│   ├── product-description.md    # Marketplace descriptions
│   ├── faq-content.md            # FAQ section
│   └── feature-pages/            # Individual feature pages
│       └── [feature-name].md
├── 04-email-sequences/           # Email campaigns
│   ├── welcome-sequence.md       # Onboarding emails
│   ├── feature-announcement.md   # New feature emails
│   ├── free-to-pro-upgrade.md    # Upgrade campaigns
│   └── re-engagement.md          # Win-back emails
├── 05-social-media/              # Social content (separate files per platform)
│   ├── twitter-posts.md          # Twitter/X content
│   ├── linkedin-posts.md         # LinkedIn content
│   ├── facebook-posts.md         # Facebook content
│   └── instagram-captions.md     # Instagram content
├── 06-sales-materials/           # Sales enablement
│   ├── one-pager.md              # Quick sales sheet
│   ├── objection-handling.md     # Sales FAQ responses
│   ├── feature-comparison-chart.md # Competitive comparison
│   ├── roi-calculator-content.md # Value justification
│   └── testimonials.md           # Customer quotes
├── 07-brand-assets/              # Brand guidelines
│   ├── persona-profiles.md       # Target customer profiles
│   ├── messaging-guide.md        # Voice and messaging
│   └── seo-keywords.md           # Keywords and meta content
└── README.md                     # Index and quick reference
```

## Instructions

### 1. Always Start with Personas

Before creating content, define 3-5 target personas in `07-brand-assets/persona-profiles.md`:

```markdown
## Persona: [Name]

### Demographics
- Role, Age, Team Size, Industry, Technical Level

### Goals
- What they want to achieve

### Pain Points
- Problems they face

### Why Product Appeals
- Feature-to-benefit mapping

### Key Message
> "One sentence that resonates with this persona"

### Content They Respond To
- Types of content that work
```

### 2. Product Descriptions

Lead with benefits, not features:

```
❌ "Includes auto-moderation feature"
✅ "Stop spam automatically — so you can focus on growing your community"
```

Use power words: effortless, powerful, stunning, seamless, instant, automatic

### 3. Feature Highlights

Transform every feature into a benefit using:
- "so you can..."
- "which means..."

```markdown
**What It Does:**
[Feature description]

**The Benefit:**
[Power word] + [outcome] — so you can [user benefit].

**Why It Matters:**
- [Feature detail], which means [benefit]
- [Feature detail], so you can [benefit]
```

### 4. Video Scripts

Structure for each video:
```markdown
## Video Details
- Title, Duration, Purpose, Tone, Target

## Script

### INTRO (0:00 - 0:XX)
**VISUAL:** [Description]
**NARRATOR:** "[Script]"
**ON-SCREEN TEXT:** "[Text overlay]"

### [SECTION NAME] (X:XX - X:XX)
...

## Production Notes
- Visual style
- Music suggestions
- Screenshots needed
```

### 5. Social Media (Separate Files Per Platform)

**Twitter/X:** (`twitter-posts.md`)
- Hook in first line
- 1-2 key benefits
- Emoji for visual breaks
- Thread format for longer content

**LinkedIn:** (`linkedin-posts.md`)
- Professional tone
- Problem → Solution format
- Statistics and proof points
- Thought leadership angle

**Facebook:** (`facebook-posts.md`)
- Community-focused
- Storytelling approach
- Engagement questions

**Instagram:** (`instagram-captions.md`)
- Visual-first (describe image needed)
- Short, punchy captions
- Carousel/Reel ideas included

### 6. Email Campaigns

Structure each email file with multiple templates:
- Subject line variations (A/B test)
- Full email body
- CTA options

### 7. Sales Materials

**One-Pager:** Print-ready summary with:
- Problem/Solution
- Key features (3-5)
- Results/Stats
- Pricing
- CTA

**Objection Handling:** For each objection:
- Understand (clarifying questions)
- Acknowledge (validate concern)
- Address (provide information)
- Confirm (check if resolved)

**ROI Calculator:** Include:
- Input variables
- Calculation formulas
- Result display templates
- Comparison scenarios

### 8. Pricing Messaging

Always include accurate pricing from product page:
```markdown
| License | Price | Sites |
|---------|-------|-------|
| Single | $XX/yr | 1 site |
| 5 License | $XX/yr | 5 sites |
| Developer | $XX/yr | Unlimited |
```

### Tone Guidelines

- Confident but not arrogant
- Helpful and solution-focused
- Professional yet friendly
- Direct without jargon
- Use "you" more than "we"
- Focus on outcomes, not outputs

### SEO Considerations

Include in `07-brand-assets/seo-keywords.md`:
- Primary keywords (5-10)
- Secondary keywords (10-20)
- Long-tail keywords
- Meta descriptions for each page type
- Schema markup suggestions

### Quality Checklist

Before completing, verify:
- [ ] Personas defined
- [ ] All folders created
- [ ] Pricing accurate
- [ ] Benefits (not just features)
- [ ] "so you can..." language used
- [ ] Social media split by platform
- [ ] Objection handling complete
- [ ] README index updated

