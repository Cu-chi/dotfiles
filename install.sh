#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO="https://raw.githubusercontent.com/Cu-chi/dotfiles/master"

echo -e "${BLUE}Installation de oh-my-zsh...${NC}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "${BLUE}Installation des dotfiles...${NC}"

echo -e "${GREEN}✓ Installation terminée !${NC}"
