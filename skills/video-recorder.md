# Video Recorder

Record browser interactions with captions for QA, documentation, and marketing.

## Requirements

Before using this skill, verify these dependencies are installed:

### Required: Playwright MCP
Check if Playwright MCP is available:
```
mcp__plugin_playwright_playwright__browser_navigate
```

If not available, install via Claude Code plugins:
```bash
# The Playwright MCP should be configured at:
# ~/.claude/plugins/marketplaces/claude-plugins-official/external_plugins/playwright/.mcp.json

# Config should include video recording args:
{
  "playwright": {
    "command": "npx",
    "args": [
      "@playwright/mcp@latest",
      "--save-video=1920x1080",
      "--output-dir=./docs/videos"
    ]
  }
}
```

### Required: ffmpeg (for captions)
```bash
# Check if installed
which ffmpeg

# If not installed
brew install ffmpeg
```

### Required: Output directory
```bash
mkdir -p ./docs/videos
```

---

## Use Cases

- **QA Testing** - Record test runs for bug reports and verification
- **Documentation** - Step-by-step guides with visual walkthroughs
- **Marketing** - Product demos showing features in action
- **Support** - "How to" videos for common tasks
- **Onboarding** - New user tutorials with captions

---

## Workflow

### Step 1: Record Video
```
1. Navigate to the starting URL
2. Perform actions (clicks, form fills, etc.)
3. Close browser to finalize recording
4. Video saved to: ./docs/videos/page-{timestamp}.webm
```

### Step 2: Check Duration
```bash
ffmpeg -i ./docs/videos/page-{timestamp}.webm 2>&1 | grep Duration
```

### Step 3: Create Captions (SRT)
Create `.srt` file with same name as video:
```srt
1
00:00:00,000 --> 00:00:10,000
First action description
Additional context

2
00:00:10,000 --> 00:00:20,000
Second action description
More details
```

### Step 4: Burn Captions into Video
```bash
ffmpeg -i video.webm \
  -vf "subtitles=video.srt:force_style='FontSize=24,PrimaryColour=&HFFFFFF,OutlineColour=&H000000,BorderStyle=3,Outline=2'" \
  -c:a copy video-captioned.mp4 -y
```

---

## Output Files

| File | Purpose |
|------|---------|
| `page-{timestamp}.webm` | Original recording (1920x1080) |
| `page-{timestamp}.srt` | Subtitle file (editable, translatable) |
| `page-{timestamp}-captioned.mp4` | Video with burned-in captions |

---

## Timestamp Tracking

While recording, log actions with timestamps:
```
START: 0:00
0:05 - Navigated to dashboard
0:12 - Clicked Settings tab
0:20 - Filled form field
0:28 - Clicked Save button
```

Then convert to SRT format.

---

## Tips

- **Keep videos short** (30-60 seconds) for better engagement
- **Use consistent timing** (~10 seconds per action)
- **Add context in captions** (what + why)
- **Add `docs/videos/` to .gitignore** to avoid committing large files
- **SRT files are translatable** for international docs
