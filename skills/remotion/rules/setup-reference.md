# Remotion + Launchpad + CUA Setup Reference

Complete setup guide for replicating the video creation environment on a new Mac.

## Prerequisites

### macOS Requirements
- macOS 12+ (Monterey or later recommended)
- Apple Silicon (M1/M2/M3) or Intel Mac
- Xcode Command Line Tools: `xcode-select --install`

### Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## Global Tools Installation

### 1. Node.js (v20+ recommended)
```bash
# Via Homebrew
brew install node

# Or via nvm (recommended for version management)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 22
nvm use 22

# Verify
node --version  # Should be v20+ or v22+
```

### 2. pnpm (Package Manager)
```bash
brew install pnpm

# Or via npm
npm install -g pnpm

# Or via corepack (Node 16.13+)
corepack enable pnpm

# Verify
pnpm --version  # Should be 9+ or 10+
```

### 3. ffmpeg (Video Processing)
```bash
brew install ffmpeg

# Verify
ffmpeg -version
```

### 4. uv (Python Package Manager - for CUA)
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH (add to ~/.zshrc or ~/.bashrc)
export PATH="$HOME/.local/bin:$PATH"

# Verify
uv --version  # Should be 0.5+
```

### 5. Python 3.12+ (for CUA)
```bash
# uv will install Python automatically, or:
brew install python@3.12

# Verify
python3 --version
```

### 6. Git
```bash
# Usually pre-installed, or:
brew install git

# Verify
git --version
```

---

## Repository Setup

### Directory Structure
```
~/tools/
├── launchpad/     # Remotion video monorepo
└── cua/           # Computer-Use Agent
```

### 1. Clone Repositories
```bash
# Create tools directory
mkdir -p ~/tools && cd ~/tools

# Clone Launchpad (Remotion video creation)
git clone https://github.com/trycua/launchpad.git

# Clone CUA (Computer-Use Agent)
git clone https://github.com/trycua/cua.git
```

### 2. Setup Launchpad
```bash
cd ~/tools/launchpad

# Install dependencies (with dev dependencies)
NODE_ENV=development pnpm install

# Build packages
pnpm build

# Verify Remotion works
cd videos/cuabench
npx remotion render src/remotion/index.ts CuaBenchFull out/test.mp4 --frames=0-30
```

### 3. Setup CUA
```bash
cd ~/tools/cua

# Install Python dependencies (creates .venv automatically)
uv sync --all-packages

# Verify installation
source .venv/bin/activate
python -c "from agent import ComputerAgent; from computer import Computer; print('CUA OK')"
```

---

## Claude Code Skills Installation

### Install Remotion Skills
```bash
# Create skills directory if needed
mkdir -p ~/.claude/skills

# Clone remotion skills
cd /tmp
git clone https://github.com/remotion-dev/skills.git remotion-skills

# Copy to Claude Code skills
cp -r remotion-skills/skills/remotion ~/.claude/skills/
```

### Verify Skills
```bash
ls ~/.claude/skills/remotion/
# Should show: SKILL.md, rules/
```

---

## Version Reference

Tested with these versions (January 2026):

| Tool | Version | Install Command |
|------|---------|-----------------|
| Node.js | v22.14.0 | `brew install node` |
| pnpm | 10.28.1 | `brew install pnpm` |
| ffmpeg | 8.0.1 | `brew install ffmpeg` |
| uv | 0.9.25 | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Python | 3.12+ | Auto-installed by uv |
| Remotion | 4.0.407 | Via pnpm in launchpad |
| Turbo | 2.7.5 | Via pnpm in launchpad |

---

## Quick Setup Script

Save this as `setup-remotion-env.sh`:

```bash
#!/bin/bash
set -e

echo "=== Remotion + Launchpad + CUA Setup ==="

# Check Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install global tools
echo "Installing global tools..."
brew install node pnpm ffmpeg git

# Install uv
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Create tools directory
mkdir -p ~/tools && cd ~/tools

# Clone repositories
echo "Cloning repositories..."
[ ! -d "launchpad" ] && git clone https://github.com/trycua/launchpad.git
[ ! -d "cua" ] && git clone https://github.com/trycua/cua.git

# Setup Launchpad
echo "Setting up Launchpad..."
cd ~/tools/launchpad
NODE_ENV=development pnpm install
pnpm build

# Setup CUA
echo "Setting up CUA..."
cd ~/tools/cua
uv sync --all-packages

# Setup Claude Code skills
echo "Setting up Remotion skills..."
mkdir -p ~/.claude/skills
cd /tmp
[ ! -d "remotion-skills" ] && git clone https://github.com/remotion-dev/skills.git remotion-skills
cp -r remotion-skills/skills/remotion ~/.claude/skills/

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Launchpad: ~/tools/launchpad"
echo "CUA: ~/tools/cua"
echo "Skills: ~/.claude/skills/remotion"
echo ""
echo "Quick commands:"
echo "  cd ~/tools/launchpad && pnpm create-video"
echo "  cd ~/tools/cua && source .venv/bin/activate"
```

Make executable and run:
```bash
chmod +x setup-remotion-env.sh
./setup-remotion-env.sh
```

---

## Verification Checklist

Run these commands to verify everything is working:

```bash
# 1. Global tools
node --version          # v20+ or v22+
pnpm --version          # 9+ or 10+
ffmpeg -version         # Any recent version
uv --version            # 0.5+

# 2. Launchpad
cd ~/tools/launchpad
pnpm build              # Should complete without errors

# 3. Remotion render test
cd ~/tools/launchpad/videos/cuabench
npx remotion render src/remotion/index.ts CuaBenchFull out/test.mp4 --frames=0-30
# Should create out/test.mp4

# 4. CUA
cd ~/tools/cua
source .venv/bin/activate
python -c "from agent import ComputerAgent; print('OK')"
# Should print "OK"

# 5. Skills
ls ~/.claude/skills/remotion/SKILL.md
# Should exist
```

---

## Troubleshooting

### pnpm install fails with permission error
```bash
# Use Homebrew instead of npm global install
brew install pnpm
```

### NODE_ENV=production skipping devDependencies
```bash
# Explicitly set development mode
NODE_ENV=development pnpm install
```

### Remotion Chrome Headless Shell download
```bash
# First render will download automatically
# Or pre-download:
npx remotion browser ensure
```

### CUA Python version issues
```bash
# uv automatically manages Python versions
# Force specific version:
uv python install 3.12
uv sync --all-packages
```

### ffmpeg codec issues
```bash
# Reinstall with all codecs
brew reinstall ffmpeg
```

---

## Environment Variables (Optional)

Add to `~/.zshrc` or `~/.bashrc`:

```bash
# uv
export PATH="$HOME/.local/bin:$PATH"

# Launchpad shortcut
alias launchpad="cd ~/tools/launchpad"
alias cua="cd ~/tools/cua && source .venv/bin/activate"

# Remotion shortcuts
alias remotion-studio="npx remotion studio"
alias remotion-render="npx remotion render"
```

---

## Updates

### Update Launchpad
```bash
cd ~/tools/launchpad
git pull
pnpm install
pnpm build
```

### Update CUA
```bash
cd ~/tools/cua
git pull
uv sync --all-packages
```

### Update Remotion Skills
```bash
cd /tmp
rm -rf remotion-skills
git clone https://github.com/remotion-dev/skills.git remotion-skills
cp -r remotion-skills/skills/remotion ~/.claude/skills/
```
