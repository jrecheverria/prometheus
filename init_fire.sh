#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Resolve the directory this script lives in, so paths work no matter where it's run from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging helpers
log()  { echo -e "${BLUE}==>${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
ok()   { echo -e "${GREEN}✓${NC} $1"; }
err()  { echo -e "${RED}✗${NC} $1"; }

log "${BOLD}starting master configuration script${NC}"

# Step 1. Check if homebrew is installed
log "checking if homebrew is installed"
if ! command -v brew > /dev/null 2>&1; then
    warn "brew not installed, installing homebrew first"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    ok "brew is installed"
fi

# Step 2. Check if ghostty is installed
log "checking if ghostty is installed"
if [[ ! -d "/Applications/Ghostty.app" ]] && ! command -v ghostty > /dev/null 2>&1; then
    warn "ghostty not installed, installing via brew"
    brew install --cask ghostty
else
    ok "ghostty is installed"
fi

# Step 3. Check if the ghostty config directory exists
if [[ ! -d "$HOME/.config/ghostty" ]]; then
    warn "ghostty config directory not present, creating it"
    mkdir -p "$HOME/.config/ghostty"
fi

log "writing ghostty config"
if [[ ! -f "$SCRIPT_DIR/ghostty_config.txt" ]]; then
    err "source config not found at $SCRIPT_DIR/ghostty_config.txt"
    exit 1
fi
cat "$SCRIPT_DIR/ghostty_config.txt" > "$HOME/.config/ghostty/config"
ok "ghostty config written to $HOME/.config/ghostty/config"

# Step 4. Install github cli
if ! command -v gh > /dev/null 2>&1; then
    warn "github cli not installed, installing github cli via brew"
    brew install gh     
fi

# Step 5. Install neovim 
if ! command -v nvim > /dev/null 2>&1; then
      warn "neovim not installed, installing neovim via brew"
      brew install neovim
else  
      ok "neovim is installed"
fi       

# Step 6. Install ripgrep and fd for telescope to work
if ! command -v ripgrep > /dev/null 2>&1; then
      warn "ripgrep not installed, installing ripgrep via brew"
      brew install ripgrep          
fi

if ! command -v fd > /dev/null 2>&1; then
      warn "fd not installed, installing fd via brew"
      brew install fd 
fi

# Step 6. Install kickstart for minimal neovim configuration
log "beggining neovim configuration. installing kickstart"
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
ok "kick start installed in /.config/nvim directory"

