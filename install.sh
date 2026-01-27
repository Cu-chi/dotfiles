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

# 2. RUST Installation (Required for eza, bat, ripgrep, alacritty)
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

install_cargo_tool "eza"       # Replacement for ls
install_cargo_tool "bat"       # Replacement for cat
install_cargo_tool "ripgrep"   # Replacement for grep
install_cargo_tool "fd-find"   # Replacement for find (Required for Telescope)
install_cargo_tool "alacritty" # GPU-accelerated terminal emulator

# Configure Alacritty Desktop Shortcut
if command -v alacritty &> /dev/null; then
    echo -e "${YELLOW}:: Creating Desktop shortcut for Alacritty...${NC}"

    mkdir -p "$HOME/.local/share/applications"
    mkdir -p "$HOME/.local/share/icons"

    # 2. Download official icon
    if [ ! -f "$HOME/.local/share/icons/Alacritty.svg" ]; then
        wget -q -O "$HOME/.local/share/icons/Alacritty.svg" \
        "https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/alacritty-term.svg"
    fi

    # 3. Create .desktop file
    # Allows GNOME to recognize the application
    cat > "$HOME/.local/share/applications/alacritty.desktop" <<EOF
[Desktop Entry]
Type=Application
TryExec=$HOME/.cargo/bin/alacritty
Exec=$HOME/.cargo/bin/alacritty
Icon=$HOME/.local/share/icons/Alacritty.svg
Terminal=false
Categories=System;TerminalEmulator;

Name=Alacritty
GenericName=Terminal
Comment=A fast, cross-platform, OpenGL terminal emulator
StartupNotify=true
EOF

    # Set Alacritty as default terminal
    gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
    
    echo -e "${GREEN}:: Alacritty shortcut created and set as default!${NC}"
fi

# 4. Starship Installation (Prompt)
if ! command -v starship &> /dev/null; then
    echo -e "${YELLOW}:: Installing Starship...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir "$BIN_DIR"
else
    echo -e "${GREEN}:: Starship is already installed.${NC}"
fi

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

    # 1. If the destination exists and is a REAL directory (not a link), backup it
    if [ -d "$dest" ] && [ ! -L "$dest" ]; then
        echo "   Backing up existing directory: $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    # 2. If the destination exists and is a REAL file (not a link), backup it
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        echo "   Backing up existing file: $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    # 3. If it's already a symbolic link, remove it first
    # (This fixes the infinite loop bug)
    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    # 4. Create the new link cleanly
    ln -s "$src" "$dest"
    echo -e "   ${GREEN}OK${NC} $dest"
}

create_link "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
create_link "$DOTFILES_DIR/starship.toml" "$CONFIG_DIR/starship.toml"

# Alacritty
mkdir -p "$CONFIG_DIR/alacritty"
create_link "$DOTFILES_DIR/alacritty.toml" "$CONFIG_DIR/alacritty/alacritty.toml"

# nvim (Config only, binary must be installed manually or via other means)
create_link "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"

echo -e "${BLUE}===============================================${NC}"
echo -e "${GREEN}✅ Installation successfully completed!${NC}"
echo -e "${BLUE}===============================================${NC}"
echo -e "👉 To finalize: type ${YELLOW}exec zsh${NC} or restart your terminal."