# =============================================================================
#  CONFIGURATION ZSH - 42 LYON
#  User: equentin
# =============================================================================

# --- 1. Variables d'environnement ---
export USER="equentin"
export MAIL="equentin@student.42lyon.fr"
export LANG=en_US.UTF-8

# Gestion du PATH (Regroupé pour la lisibilité)
# Ajout de .local/bin (pip, scripts) et .cargo/bin (Rust/eza/bat)
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# --- 2. Configuration de l'historique ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY          # Partager l'historique entre les terminaux
setopt HIST_IGNORE_ALL_DUPS   # Pas de doublons
setopt HIST_FIND_NO_DUPS      # Pas de doublons lors de la recherche
setopt HIST_REDUCE_BLANKS     # Enlever les espaces inutiles

# =============================================================================
#  ZINIT (Gestionnaire de Plugins)
# =============================================================================

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Chargement des annexes Zinit (Requis pour le fonctionnement interne)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# --- Plugins Visuels & Productivité ---
zinit light zsh-users/zsh-autosuggestions    # Suggestions grises
zinit light zsh-users/zsh-completions        # Complétions supplémentaires
zinit light zsh-users/zsh-syntax-highlighting # Coloration des commandes (A charger en dernier)

# =============================================================================
#  OUTILS EXTERNES (Lazy Loading)
# =============================================================================

# --- NVM (Node Version Manager) ---
# Chargement différé de 1 seconde pour ne pas ralentir le démarrage
zinit ice wait"1" lucid
zinit light lukechilds/zsh-nvm

# --- FZF (Fuzzy Finder) ---
# Configuration "Force Brute" pour s'assurer que le binaire est trouvé
zinit ice as"command" depth=1 \
    atclone"./install --bin" \
    atpull"%atclone" \
    pick"bin/fzf" \
    multisrc"shell/{completion,key-bindings}.zsh"
zinit light junegunn/fzf

# Sécurité : Ajout manuel au PATH pour FZF
export PATH="$HOME/.local/share/zinit/plugins/junegunn---fzf/bin:$PATH"

# =============================================================================
#  SYSTÈME DE COMPLÉTION (Optimisé pour 42/NFS)
# =============================================================================

autoload -Uz compinit
# Si le cache (.zcompdump) a moins de 24h, on l'utilise sans vérifier (rapide)
# Sinon, on le régénère (lent, mais nécessaire 1x/jour)
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh-24) ]]; then
    compinit -C
else
    compinit -i
fi

zinit cdreplay -q

# =============================================================================
#  ALIASES
# =============================================================================

# --- Outils 42 ---
alias paco='$HOME/francinette/tester.sh'
alias zft='bash $HOME/Downloads/zft/run.sh'

# --- Utilitaires ---
alias c='clear'
alias ..='cd ..'
alias ll='eza -l'
alias la='eza -la'
alias cat='bat'

# --- Compilation C ---
alias ccw='cc -Wall -Wextra -Werror'
alias val='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'

# =============================================================================
#  INTERFACE (Prompt)
# =============================================================================

# Lancement de Starship
eval "$(starship init zsh)"