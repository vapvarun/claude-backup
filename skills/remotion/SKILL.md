---
name: remotion
description: Best practices for Remotion - Video creation in React. Includes Launchpad monorepo components and CUA integration.
metadata:
  tags: remotion, video, react, animation, composition, launchpad, cua
---

## When to use

Use this skill whenever you are dealing with Remotion code to obtain domain-specific knowledge, creating videos with Launchpad, or integrating with CUA for AI-driven video creation.

## Setup Guide

For complete setup on a new Mac, see **[rules/setup-reference.md](rules/setup-reference.md)** which includes:
- Global tools installation (Node.js, pnpm, ffmpeg, uv)
- Repository cloning and setup
- Quick setup script
- Verification checklist
- Troubleshooting guide

## Local Setup (Current Machine)

### Repositories
- **Launchpad**: `/Users/varundubey/tools/launchpad` - React video creation monorepo
- **CUA**: `/Users/varundubey/tools/cua` - Computer-Use Agent for AI automation

### Quick Commands
```bash
# Launchpad
cd /Users/varundubey/tools/launchpad
pnpm create-video                    # Create new video project
pnpm --filter=@launchpad/cuabench remotion studio  # Open Remotion Studio
npx remotion render src/remotion/index.ts <CompositionId> out/video.mp4

# CUA
cd /Users/varundubey/tools/cua
source .venv/bin/activate
python examples/agent/anthropic_example.py
```

---

## Launchpad Shared Components

### Animation Components

#### FadeIn
```tsx
import { FadeIn } from '@launchpad/shared';

<FadeIn
  durationInFrames={20}    // Animation length (default: 20)
  delay={0}                // Start delay in frames
  direction="up"           // "up" | "down" | "left" | "right" | "none"
  distance={30}            // Pixels to travel (default: 30)
  easing={Easing.out(Easing.cubic)}
>
  <h1>Your Content</h1>
</FadeIn>
```

#### TextReveal
```tsx
import { TextReveal } from '@launchpad/shared';

<TextReveal
  durationInFrames={30}
  delay={0}
  direction="left"         // "left" | "right"
  maskColor="#000"
>
  <span style={{ fontSize: 80 }}>Revealed Text</span>
</TextReveal>
```

#### SlideUp
```tsx
import { SlideUp } from '@launchpad/shared';

<SlideUp durationInFrames={25} delay={10}>
  <div>Slides up with fade</div>
</SlideUp>
```

### Hooks

#### useAnimatedValue
```tsx
import { useAnimatedValue } from '@launchpad/shared';

const opacity = useAnimatedValue({
  from: 0,
  to: 1,
  durationInFrames: 30,
  delay: 10,
  easing: Easing.out(Easing.cubic),
});
```

#### useFadeIn
```tsx
import { useFadeIn } from '@launchpad/shared';

const { opacity } = useFadeIn({ durationInFrames: 20, delay: 5 });
```

### Easing Presets
```tsx
import { easings } from '@launchpad/shared';

// Available easings:
easings.smooth   // Easing.out(Easing.cubic) - most common
easings.bounce   // Easing.out(Easing.back(1.5))
easings.linear   // Easing.linear
easings.inOut    // Easing.inOut(Easing.cubic)
easings.sharp    // Easing.out(Easing.quad)
easings.elastic  // Easing.out(Easing.elastic(1))
```

### Timing Utilities
```tsx
import { framesToSeconds, secondsToFrames, formatDuration } from '@launchpad/shared';

framesToSeconds(90, 30);    // 3
secondsToFrames(5, 30);     // 150
formatDuration(180, 30);    // "0:06"
```

### Video Presets
```tsx
import { VIDEO_PRESETS, FPS } from '@launchpad/shared';

VIDEO_PRESETS["1080p"]  // { width: 1920, height: 1080 }
VIDEO_PRESETS["720p"]   // { width: 1280, height: 720 }
VIDEO_PRESETS["4k"]     // { width: 3840, height: 2160 }
VIDEO_PRESETS.square    // { width: 1080, height: 1080 }
VIDEO_PRESETS.vertical  // { width: 1080, height: 1920 }

FPS.STANDARD   // 30
FPS.CINEMATIC  // 24
FPS.SMOOTH     // 60
```

---

## Launchpad Brand Assets

### Colors
```tsx
import { COLORS } from '@launchpad/assets';

COLORS.primary          // "#0070f3"
COLORS.background.dark  // "#000000"
COLORS.background.cream // "#FDF8F3"
COLORS.text.primary     // "#1a1a1a"
COLORS.accent.success   // "#10b981"
```

### Fonts
```tsx
import { FONTS, loadFonts } from '@launchpad/assets';

// In Root.tsx or composition entry:
const { fontFamily } = loadFonts();

// Use in styles:
style={{ fontFamily: fontFamily.heading }}  // Urbanist
style={{ fontFamily: fontFamily.body }}     // Inter
style={{ fontFamily: fontFamily.mono }}     // JetBrains Mono
```

---

## Creating a New Video Project

### 1. Scaffold with CLI
```bash
cd /Users/varundubey/tools/launchpad
pnpm create-video
```

### 2. Project Structure
```
videos/your-video/
├── src/
│   └── remotion/
│       ├── Root.tsx          # Register compositions
│       ├── index.ts          # Entry point
│       └── scenes/           # Scene components
├── public/                   # Assets (audio, images, video)
└── types/constants.ts        # Dimensions, FPS
```

### 3. Basic Scene Template
```tsx
// src/remotion/scenes/IntroScene.tsx
import { AbsoluteFill, useCurrentFrame, interpolate } from 'remotion';
import { FadeIn, easings } from '@launchpad/shared';
import { COLORS, loadFonts } from '@launchpad/assets';

export const INTRO_DURATION = 90; // 3 seconds at 30fps

export const IntroScene: React.FC = () => {
  const frame = useCurrentFrame();
  const { fontFamily } = loadFonts();

  return (
    <AbsoluteFill style={{ backgroundColor: COLORS.background.dark }}>
      <FadeIn durationInFrames={30} direction="up">
        <h1 style={{
          color: COLORS.text.inverse,
          fontFamily: fontFamily.heading,
          fontSize: 80,
        }}>
          Your Title
        </h1>
      </FadeIn>
    </AbsoluteFill>
  );
};
```

### 4. Register in Root.tsx
```tsx
import { Composition } from 'remotion';
import { IntroScene, INTRO_DURATION } from './scenes/IntroScene';
import { VIDEO_WIDTH, VIDEO_HEIGHT, VIDEO_FPS } from '../../types/constants';

export const Root: React.FC = () => (
  <Composition
    id="IntroScene"
    component={IntroScene}
    durationInFrames={INTRO_DURATION}
    fps={VIDEO_FPS}
    width={VIDEO_WIDTH}
    height={VIDEO_HEIGHT}
  />
);
```

### 5. Render
```bash
npx remotion render src/remotion/index.ts IntroScene out/intro.mp4
```

---

## Remotion Core Patterns

Read individual rule files for detailed explanations:

- [rules/animations.md](rules/animations.md) - Fundamental animation skills
- [rules/timing.md](rules/timing.md) - Interpolation and easing
- [rules/sequencing.md](rules/sequencing.md) - Scene sequencing patterns
- [rules/audio.md](rules/audio.md) - Audio import, volume, trimming
- [rules/videos.md](rules/videos.md) - Video embedding and manipulation
- [rules/fonts.md](rules/fonts.md) - Loading Google Fonts
- [rules/text-animations.md](rules/text-animations.md) - Typography animations
- [rules/transitions.md](rules/transitions.md) - Scene transitions
- [rules/compositions.md](rules/compositions.md) - Defining compositions
- [rules/calculate-metadata.md](rules/calculate-metadata.md) - Dynamic metadata
- [rules/display-captions.md](rules/display-captions.md) - TikTok-style captions
- [rules/transcribe-captions.md](rules/transcribe-captions.md) - Auto-transcription
- [rules/tailwind.md](rules/tailwind.md) - Using TailwindCSS
- [rules/3d.md](rules/3d.md) - Three.js integration
- [rules/lottie.md](rules/lottie.md) - Lottie animations
- [rules/charts.md](rules/charts.md) - Data visualization
- [rules/maps.md](rules/maps.md) - Mapbox integration

---

## CUA Integration

### AI-Driven Video Creation
```python
# Using CUA to automate video creation
from agent import ComputerAgent
from computer import Computer

computer = Computer(os_type="macos")
agent = ComputerAgent(
    model="anthropic/claude-sonnet-4-5-20250929",
    computer=computer
)

# Example: Automate Remotion Studio interactions
async for result in agent.run([{
    "role": "user",
    "content": "Open Remotion Studio at /Users/varundubey/tools/launchpad/videos/cuabench and render the CuaBenchFull composition"
}]):
    print(result)
```

### Available Compositions (cuabench example)
- `CuaBenchCombinedIntro` - Word-by-word intro with typing
- `CuaBenchCodeEditor` - Code editing simulation
- `CuaBenchRegistry` - Package registry showcase
- `CuaBenchFull` - Complete video (all scenes)

---

## Common Patterns

### Staggered Animations
```tsx
const items = ['Item 1', 'Item 2', 'Item 3'];
const STAGGER_DELAY = 10;

{items.map((item, i) => (
  <FadeIn key={i} delay={i * STAGGER_DELAY} direction="up">
    <div>{item}</div>
  </FadeIn>
))}
```

### Counter Animation
```tsx
const count = useAnimatedValue({
  from: 0,
  to: 100,
  durationInFrames: 60,
  easing: easings.smooth,
});

<span>{Math.floor(count)}%</span>
```

### Background Music with Fade
```tsx
import { Audio, Sequence, interpolate, useCurrentFrame } from 'remotion';

const frame = useCurrentFrame();
const volume = interpolate(frame, [0, 30, DURATION - 30, DURATION], [0, 0.5, 0.5, 0]);

<Sequence from={0}>
  <Audio src={staticFile('music.mp3')} volume={volume} />
</Sequence>
```

### Phase-Based Animation
```tsx
const PHASE1_END = 60;
const PHASE2_START = 70;

const isPhase1 = frame < PHASE1_END;
const phase2Frame = Math.max(0, frame - PHASE2_START);

// Different animations per phase
const value = isPhase1
  ? interpolate(frame, [0, PHASE1_END], [0, 50])
  : interpolate(phase2Frame, [0, 60], [50, 100]);
```
