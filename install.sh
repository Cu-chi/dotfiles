#!/bin/bash

# ==============================================================================
#  AUTOMATED INSTALLATION - 42 ENVIRONMENT
# ==============================================================================

# --- Styling Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Paths ---
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"
FONT_DIR="$HOME/.local/share/fonts"

# Add local bins to PATH for the duration of the script
export PATH="$HOME/.cargo/bin:$BIN_DIR:$PATH"

echo -e "${BLUE}🚀 Starting environment installation...${NC}"

# 1. Create base directories
echo -e "${YELLOW}:: Checking directories...${NC}"
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$FONT_DIR"

# 2. RUST Installation (Required for eza, bat, ripgrep)
if ! command -v cargo &> /dev/null; then
    echo -e "${YELLOW}:: Installing Rust (Cargo)...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo -e "${GREEN}:: Rust is already installed.${NC}"
fi

# 3. Modern tools installation (via Cargo)
install_cargo_tool() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${YELLOW}:: Installing $1... (May take a while)${NC}"
        cargo install $1
    else
        echo -e "${GREEN}:: $1 is already installed.${NC}"
    fi
}

install_neovim() {
    if ! command -v nvim &> /dev/null; then
        echo -e "${YELLOW}:: Installing Neovim (Latest Stable)...${NC}"
        # Download AppImage
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        
        # Make executable
        chmod u+x nvim.appimage
        
        # Move to local binary folder
        mv nvim.appimage "$BIN_DIR/nvim"
        
        echo -e "${GREEN}:: Neovim installed!${NC}"
    else
        echo -e "${GREEN}:: Neovim is already installed.${NC}"
    fi
}

install_cargo_tool "eza"       # Replacement for ls
install_cargo_tool "bat"       # Replacement for cat
install_cargo_tool "ripgrep"   # Replacement for grep
# Note: Alacritty takes long to compile, skipping for now unless you really want to wait 10min
# install_cargo_tool "alacritty" 

# 4. Starship Installation (Prompt)
if ! command -v starship &> /dev/null; then
    echo -e "${YELLOW}:: Installing Starship...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir "$BIN_DIR"
else
    echo -e "${GREEN}:: Starship is already installed.${NC}"
fi

install_neovim

# 5. Nerd Fonts
FONT_NAME="JetBrainsMono"
if [ ! -f "$FONT_DIR/${FONT_NAME}NerdFont-Regular.ttf" ]; then
    echo -e "${YELLOW}:: Downloading ${FONT_NAME} Nerd Font...${NC}"
    wget -q --show-progress -O "$FONT_DIR/${FONT_NAME}NerdFont-Regular.ttf" \
    "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
    
    # Refresh Fonts
    echo -e "${YELLOW}:: Updating font cache...${NC}"
    fc-cache -f "$FONT_DIR"
else
    echo -e "${GREEN}:: Nerd Font already installed.${NC}"
fi

# 6. Symlinks
echo -e "${YELLOW}:: Configuring Dotfiles (Symlinks)...${NC}"

create_link() {
    src=$1
    dest=$2
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        echo "   Backing up existing: $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi
    ln -sf "$src" "$dest"
    echo -e "   ${GREEN}OK${NC} $dest"
}

create_link "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
create_link "$DOTFILES_DIR/starship.toml" "$CONFIG_DIR/starship.toml"

# Alacritty
mkdir -p "$CONFIG_DIR/alacritty"
create_link "$DOTFILES_DIR/alacritty.toml" "$CONFIG_DIR/alacritty/alacritty.toml"

# nvim
create_link "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"

echo -e "${BLUE}===============================================${NC}"
echo -e "${GREEN}✅ Installation successfully completed!${NC}"
echo -e "${BLUE}===============================================${NC}"
echo -e "👉 To finalize: type ${YELLOW}exec zsh${NC} or restart your terminal."