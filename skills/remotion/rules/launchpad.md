# Launchpad Video Creation Patterns

## Overview

Launchpad is a Remotion-based monorepo for creating product launch videos. Located at `/Users/varundubey/tools/launchpad`.

## Monorepo Structure

```
launchpad/
├── packages/
│   ├── shared/          # @launchpad/shared - Reusable components
│   └── assets/          # @launchpad/assets - Brand colors, fonts
├── videos/
│   ├── _template/       # Scaffolding template
│   └── cuabench/        # Example video project
├── scripts/
│   └── create-video.ts  # Project generator
└── docs/                # Documentation
```

## Quick Start

```bash
cd /Users/varundubey/tools/launchpad

# Create new video project
pnpm create-video

# Work on specific project
cd videos/your-project
npx remotion studio src/remotion/index.ts  # Preview
npx remotion render src/remotion/index.ts CompositionId out/video.mp4  # Render
```

## Shared Package Exports

```tsx
// Components
import { FadeIn, SlideUp, TextReveal } from '@launchpad/shared';

// Hooks
import { useFadeIn, useAnimatedValue } from '@launchpad/shared';

// Utilities
import {
  easings,
  framesToSeconds,
  secondsToFrames,
  formatDuration
} from '@launchpad/shared';

// Types
import { VIDEO_PRESETS, FPS } from '@launchpad/shared';
```

## Assets Package Exports

```tsx
import { COLORS, FONTS, loadFonts } from '@launchpad/assets';
```

## Advanced Patterns from CuaBench

### Word-by-Word Animation

```tsx
const WORDS = ['This', 'is', 'a', 'demo'];
const WORD_DURATION = 15;
const WORD_STAGGER = 10;

const WordSequence: React.FC = () => {
  const frame = useCurrentFrame();

  return (
    <div style={{ display: 'flex', gap: 20 }}>
      {WORDS.map((word, i) => {
        const startFrame = i * WORD_STAGGER;
        const wordFrame = Math.max(0, frame - startFrame);

        const opacity = interpolate(wordFrame, [0, WORD_DURATION], [0, 1], {
          extrapolateRight: 'clamp',
          easing: Easing.out(Easing.cubic),
        });

        const y = interpolate(wordFrame, [0, WORD_DURATION], [30, 0], {
          extrapolateRight: 'clamp',
          easing: Easing.out(Easing.cubic),
        });

        return (
          <span
            key={i}
            style={{
              opacity,
              transform: `translateY(${y}px)`,
              fontSize: 80,
              fontWeight: 700,
            }}
          >
            {word}
          </span>
        );
      })}
    </div>
  );
};
```

### Typing Effect

```tsx
const TYPING_TEXT = 'Hello, World!';
const CHARS_PER_FRAME = 0.5; // Speed

const TypingText: React.FC = () => {
  const frame = useCurrentFrame();
  const charsToShow = Math.floor(frame * CHARS_PER_FRAME);
  const visibleText = TYPING_TEXT.slice(0, charsToShow);

  return (
    <div style={{ fontFamily: 'JetBrains Mono', fontSize: 48 }}>
      {visibleText}
      <span style={{ opacity: frame % 30 > 15 ? 1 : 0 }}>|</span>
    </div>
  );
};
```

### Counter with Bounce at Target

```tsx
const AnimatedCounter: React.FC<{ target: number }> = ({ target }) => {
  const frame = useCurrentFrame();
  const { fontFamily } = loadFonts();

  const ANIMATION_DURATION = 60;
  const BOUNCE_DURATION = 10;

  const rawValue = interpolate(frame, [0, ANIMATION_DURATION], [0, target], {
    extrapolateRight: 'clamp',
    easing: Easing.out(Easing.cubic),
  });

  const isComplete = frame >= ANIMATION_DURATION;

  // Bounce effect when complete
  const bounceScale = isComplete
    ? interpolate(
        frame - ANIMATION_DURATION,
        [0, BOUNCE_DURATION / 2, BOUNCE_DURATION],
        [1, 1.2, 1],
        { extrapolateRight: 'clamp' }
      )
    : 1;

  // Glow effect when complete
  const glowIntensity = isComplete
    ? interpolate(frame - ANIMATION_DURATION, [0, 20], [0, 1], {
        extrapolateRight: 'clamp',
      })
    : 0;

  return (
    <div
      style={{
        transform: `scale(${bounceScale})`,
        filter: glowIntensity > 0
          ? `drop-shadow(0 0 ${20 * glowIntensity}px ${COLORS.accent.success})`
          : 'none',
        fontSize: 120,
        fontFamily: fontFamily.heading,
        color: isComplete ? COLORS.accent.success : COLORS.text.primary,
      }}
    >
      {Math.floor(rawValue)}%
    </div>
  );
};
```

### Scene Exit Animation

```tsx
const EXIT_START = 60;
const EXIT_DURATION = 15;

const SceneWithExit: React.FC<{ totalDuration: number }> = ({ totalDuration }) => {
  const frame = useCurrentFrame();

  const exitFrame = Math.max(0, frame - EXIT_START);
  const isExiting = frame >= EXIT_START;

  const opacity = isExiting
    ? interpolate(exitFrame, [0, EXIT_DURATION], [1, 0], {
        extrapolateRight: 'clamp',
      })
    : 1;

  const y = isExiting
    ? interpolate(exitFrame, [0, EXIT_DURATION], [0, -50], {
        extrapolateRight: 'clamp',
        easing: Easing.in(Easing.cubic),
      })
    : 0;

  return (
    <AbsoluteFill style={{ opacity, transform: `translateY(${y}px)` }}>
      <h1>Scene Content</h1>
    </AbsoluteFill>
  );
};
```

### Background Video with Blur-to-Clear

```tsx
import { Video, staticFile, interpolate, useCurrentFrame } from 'remotion';

const BackgroundVideo: React.FC = () => {
  const frame = useCurrentFrame();

  const blur = interpolate(frame, [0, 30], [20, 0], {
    extrapolateRight: 'clamp',
  });

  const opacity = interpolate(frame, [0, 30], [0, 1], {
    extrapolateRight: 'clamp',
  });

  return (
    <AbsoluteFill>
      <Video
        src={staticFile('background.mp4')}
        style={{
          width: '100%',
          height: '100%',
          objectFit: 'cover',
          filter: `blur(${blur}px)`,
          opacity,
        }}
      />
      {/* Dark overlay */}
      <AbsoluteFill
        style={{
          backgroundColor: 'rgba(0, 0, 0, 0.6)',
          opacity: interpolate(frame, [20, 40], [0, 1], {
            extrapolateRight: 'clamp',
          }),
        }}
      />
    </AbsoluteFill>
  );
};
```

### Multi-Scene Composition

```tsx
import { Series, Audio, Sequence, staticFile, interpolate, useCurrentFrame } from 'remotion';

const SCENES = [
  { component: IntroScene, duration: 90 },
  { component: MainScene, duration: 150 },
  { component: OutroScene, duration: 60 },
];

const TOTAL_DURATION = SCENES.reduce((sum, s) => sum + s.duration, 0);

const FullVideo: React.FC = () => {
  const frame = useCurrentFrame();

  // Background music with fade in/out
  const volume = interpolate(
    frame,
    [0, 30, TOTAL_DURATION - 30, TOTAL_DURATION],
    [0, 0.5, 0.5, 0]
  );

  return (
    <AbsoluteFill>
      {/* Scenes */}
      <Series>
        {SCENES.map(({ component: Scene, duration }, i) => (
          <Series.Sequence key={i} durationInFrames={duration}>
            <Scene />
          </Series.Sequence>
        ))}
      </Series>

      {/* Background music */}
      <Sequence from={0} durationInFrames={TOTAL_DURATION}>
        <Audio src={staticFile('music.mp3')} volume={volume} />
      </Sequence>
    </AbsoluteFill>
  );
};
```

### Sound Effects on Animation

```tsx
import { Audio, Sequence, staticFile } from 'remotion';

const WORD_TIMING = [0, 15, 30, 45]; // Frame when each word appears

const WordsWithSound: React.FC = () => {
  return (
    <AbsoluteFill>
      {/* Visual content */}
      <WordSequence />

      {/* Sound effects */}
      {WORD_TIMING.map((startFrame, i) => (
        <Sequence key={i} from={startFrame} durationInFrames={15}>
          <Audio src={staticFile('whoosh.wav')} volume={0.3} />
        </Sequence>
      ))}
    </AbsoluteFill>
  );
};
```

## Project Configuration

### types/constants.ts
```tsx
export const VIDEO_WIDTH = 1920;
export const VIDEO_HEIGHT = 1080;
export const VIDEO_FPS = 30;
```

### Composition Registration
```tsx
// src/remotion/Root.tsx
import { Composition, Folder } from 'remotion';
import { VIDEO_WIDTH, VIDEO_HEIGHT, VIDEO_FPS } from '../../types/constants';

export const Root: React.FC = () => (
  <>
    <Folder name="Scenes">
      <Composition
        id="IntroScene"
        component={IntroScene}
        durationInFrames={INTRO_DURATION}
        fps={VIDEO_FPS}
        width={VIDEO_WIDTH}
        height={VIDEO_HEIGHT}
      />
      <Composition
        id="MainScene"
        component={MainScene}
        durationInFrames={MAIN_DURATION}
        fps={VIDEO_FPS}
        width={VIDEO_WIDTH}
        height={VIDEO_HEIGHT}
      />
    </Folder>

    <Composition
      id="FullVideo"
      component={FullVideo}
      durationInFrames={TOTAL_DURATION}
      fps={VIDEO_FPS}
      width={VIDEO_WIDTH}
      height={VIDEO_HEIGHT}
    />
  </>
);
```

## Render Commands

```bash
# Render full video
npx remotion render src/remotion/index.ts FullVideo out/video.mp4

# Render specific scene
npx remotion render src/remotion/index.ts IntroScene out/intro.mp4

# Render specific frames (for testing)
npx remotion render src/remotion/index.ts FullVideo out/test.mp4 --frames=0-60

# Render at lower quality (faster)
npx remotion render src/remotion/index.ts FullVideo out/preview.mp4 --scale=0.5

# Render with specific codec
npx remotion render src/remotion/index.ts FullVideo out/video.webm --codec=vp8
```
