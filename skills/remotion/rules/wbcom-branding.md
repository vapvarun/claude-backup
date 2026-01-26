# Wbcom Designs Video Branding Guidelines

## Overview

All videos produced for Wbcom Designs products must follow these branding guidelines for consistency.

## Logo Assets

**Location:** `/Users/varundubey/tools/wbcomlogos/`

| File | Usage |
|------|-------|
| `wbcom-logo-transparent-2.png` | Horizontal logo with text (light backgrounds) |
| `wbcom1.png` | Stacked logo (icon above text) |
| `wbcom-logo.png` | Compact horizontal logo |
| `wbcom-logo-white-*.jpg` | White versions for dark backgrounds |

## Brand Colors

```tsx
const WBCOM_COLORS = {
  // Primary brand colors
  navy: "#2d3748",      // Main text (WBCOM)
  gray: "#718096",      // Secondary text (DESIGNS)

  // Lightbulb icon colors (rainbow gradient)
  purple: "#9b59b6",
  green: "#27ae60",
  blue: "#3498db",
  cyan: "#00bcd4",
  orange: "#f39c12",
  pink: "#e91e63",
  yellow: "#f1c40f",

  // Backgrounds
  dark: "#1a1a2e",
  darkAlt: "#16213e",
  gradient: "linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)",

  // Text
  textPrimary: "#ffffff",
  textSecondary: "#a0aec0",

  // Accents
  star: "#f6e05e",      // Star ratings
  success: "#48bb78",   // CTAs, badges
  wordpress: "#0073aa", // WordPress blue
};
```

## Video Specifications

### YouTube (Default)
```tsx
// 4K - Always use for YouTube
width: 3840,
height: 2160,
fps: 30,
aspectRatio: "16:9",
```

### Social Media Variants
```tsx
// Vertical (Stories, Reels, TikTok, Shorts)
width: 1080,
height: 1920,
fps: 30,

// Square (Instagram Feed)
width: 1080,
height: 1080,
fps: 30,
```

## Typography

```tsx
// Primary font (matches logo)
fontFamily: "system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif"

// Monospace (code examples)
fontFamily: "'JetBrains Mono', 'SF Mono', Consolas, monospace"
```

### Font Sizes (4K)
| Element | Size |
|---------|------|
| Main headline | 144px |
| Secondary headline | 120px |
| Body text | 80-100px |
| Captions | 50-60px |
| Small text | 40px |

## Standard Scene Structure

### Intro Scene
- Dark gradient background
- Animated question/hook text
- Subtle visual elements

### Content Scenes
- Split layout: Screenshot + Text
- Screenshots at 1400px width (4K)
- Rounded corners (40px radius)
- Drop shadow: `0 40px 100px rgba(0,0,0,0.6)`

### CTA Scene
1. Wbcom logo (stacked, animated scale-in)
2. Plugin/product name
3. Star rating (animated)
4. "Free on WordPress.org" badge
5. Website URL: wbcomdesigns.com

## Animation Standards

```tsx
// Fade in
duration: 20 frames,
easing: Easing.out(Easing.cubic)

// Scale in (logos, badges)
duration: 25 frames,
easing: Easing.out(Easing.back(1.5))

// Slide up
distance: 60px,
duration: 20 frames

// Star rating
stagger: 5 frames per star,
easing: Easing.out(Easing.back(2))
```

## Safe Areas

- Padding: 80-120px from edges
- Logo placement: Bottom right or centered
- Text: Never closer than 5% from edges

## Required Elements

Every video MUST include:
1. Wbcom Designs logo in CTA scene
2. wbcomdesigns.com URL
3. Product name clearly displayed
4. "Free on WordPress.org" badge (if applicable)

## File Naming Convention

```
{product}-{type}-{format}.mp4

Examples:
bp-member-reviews-trust-ad-4k.mp4
bp-member-reviews-overview-youtube.mp4
bp-member-reviews-demo-vertical.mp4
```

## Render Commands

```bash
# 4K YouTube
npx remotion render src/remotion/index.ts CompositionId out/video-4k.mp4

# 1080p (faster renders for preview)
npx remotion render src/remotion/index.ts CompositionId out/video-1080p.mp4 --scale=0.5
```
