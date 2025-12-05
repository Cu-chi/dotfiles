#!/bin/bash

# ==============================================================================
#  INSTALLATION AUTOMATIQUE - ENVIRONNEMENT 42
# ==============================================================================

# --- Couleurs pour le style ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Chemins ---
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BIN_DIR="$HOME/.local/bin"
FONT_DIR="$HOME/.local/share/fonts"

# Ajout des bins locaux au PATH pour la durée du script
export PATH="$HOME/.cargo/bin:$BIN_DIR:$PATH"

echo -e "${BLUE}🚀 Démarrage de l'installation de l'environnement...${NC}"

# 1. Création des dossiers de base
echo -e "${YELLOW}:: Vérification des dossiers...${NC}"
mkdir -p "$BIN_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$FONT_DIR"

# 2. Installation de RUST (Nécessaire pour eza, bat, ripgrep)
if ! command -v cargo &> /dev/null; then
    echo -e "${YELLOW}:: Installation de Rust (Cargo)...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo -e "${GREEN}:: Rust est déjà installé.${NC}"
fi

# 3. Installation des outils modernes (via Cargo)
install_cargo_tool() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${YELLOW}:: Installation de $1... (Peut prendre un peu de temps)${NC}"
        cargo install $1
    else
        echo -e "${GREEN}:: $1 est déjà là.${NC}"
    fi
}

install_cargo_tool "eza"       # Remplaçant de ls
install_cargo_tool "bat"       # Remplaçant de cat
install_cargo_tool "ripgrep"   # Remplaçant de grep
# Note: Alacritty est long à compiler, on saute pour l'instant sauf si tu veux vraiment attendre 10min
# install_cargo_tool "alacritty" 

# 4. Installation de Starship (Prompt)
if ! command -v starship &> /dev/null; then
    echo -e "${YELLOW}:: Installation de Starship...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y --bin-dir "$BIN_DIR"
else
    echo -e "${GREEN}:: Starship est déjà là.${NC}"
fi

# 5. Installation des Polices (Nerd Fonts)
FONT_NAME="JetBrainsMono"
if [ ! -f "$FONT_DIR/${FONT_NAME}NerdFont-Regular.ttf" ]; then
    echo -e "${YELLOW}:: Téléchargement de la police ${FONT_NAME} Nerd Font...${NC}"
    # On télécharge juste la version Regular pour économiser la place et le temps
    wget -q --show-progress -O "$FONT_DIR/${FONT_NAME}NerdFont-Regular.ttf" \
    "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFont-Regular.ttf"
    
    # Rafraîchir le cache des polices
    echo -e "${YELLOW}:: Mise à jour du cache des polices...${NC}"
    fc-cache -f "$FONT_DIR"
else
    echo -e "${GREEN}:: Police Nerd Font déjà installée.${NC}"
fi

# 6. Installation des Liens Symboliques (Symlinks)
echo -e "${YELLOW}:: Configuration des Dotfiles (Symlinks)...${NC}"

create_link() {
    src=$1
    dest=$2
    if [ -f "$dest" ] && [ ! -L "$dest" ]; then
        echo "   Backup de l'existant : $dest -> $dest.bak"
        mv "$dest" "$dest.bak"
    fi
    ln -sf "$src" "$dest"
    echo -e "   ${GREEN}OK${NC} $dest"
}

create_link "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
create_link "$DOTFILES_DIR/starship.toml" "$CONFIG_DIR/starship.toml"

# Dossier spécifique pour Alacritty
mkdir -p "$CONFIG_DIR/alacritty"
create_link "$DOTFILES_DIR/alacritty.toml" "$CONFIG_DIR/alacritty/alacritty.toml"

echo -e "${BLUE}===============================================${NC}"
echo -e "${GREEN}✅ Installation terminée avec succès !${NC}"
echo -e "${BLUE}===============================================${NC}"
echo -e "👉 Pour finaliser : tape ${YELLOW}exec zsh${NC} ou redémarre ton terminal."