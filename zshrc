# =============================================================================
#  ZSH CONFIGURATION - 42 LYON
#  User: equentin
# =============================================================================

# --- 1. Environment Variables ---
export USER="equentin"
export MAIL="equentin@student.42lyon.fr"
export LANG=en_US.UTF-8

# PATH Management (Grouped for readability)
# Adding .local/bin (pip, scripts) and .cargo/bin (Rust/eza/bat)
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# --- 2. History Configuration ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY          # Share history between terminals
setopt HIST_IGNORE_ALL_DUPS   # No duplicates
setopt HIST_FIND_NO_DUPS      # No duplicates when searching
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks

# =============================================================================
#  ZINIT (Plugin Manager)
# =============================================================================

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Zinit annexes (Required for internal functionality)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# --- Visual & Productivity Plugins ---
zinit light zsh-users/zsh-autosuggestions    # Grey autosuggestions
zinit light zsh-users/zsh-completions        # Additional completions
zinit light zsh-users/zsh-syntax-highlighting # Syntax highlighting (Must be loaded last)

# =============================================================================
#  EXTERNAL TOOLS (Lazy Loading)
# =============================================================================

# --- NVM (Node Version Manager) ---
# Delayed load by 1 second to avoid slowing down startup
zinit ice wait"1" lucid
zinit light lukechilds/zsh-nvm

# --- FZF (Fuzzy Finder) ---
# "Brute Force" configuration to ensure binary is found
zinit ice as"command" depth=1 \
    atclone"./install --bin" \
    atpull"%atclone" \
    pick"bin/fzf" \
    multisrc"shell/{completion,key-bindings}.zsh"
zinit light junegunn/fzf

# Safety: Manually add FZF to PATH
export PATH="$HOME/.local/share/zinit/plugins/junegunn---fzf/bin:$PATH"

# =============================================================================
#  COMPLETION SYSTEM (Optimized for 42/NFS)
# =============================================================================

autoload -Uz compinit
# If cache (.zcompdump) is less than 24h old, use it without checking (fast)
# Otherwise, regenerate it (slow, but necessary 1x/day)
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh-24) ]]; then
    compinit -C
else
    compinit -i
fi

zinit cdreplay -q

# =============================================================================
#  ALIASES
# =============================================================================

# --- 42 Tools ---
alias paco='$HOME/francinette/tester.sh'
alias zft='bash $HOME/Downloads/zft/run.sh'

# --- Utilities ---
alias c='clear'
alias ..='cd ..'
alias ll='eza -l'
alias la='eza -la'
alias cat='bat'
mkcd() { mkdir -p "$@" && cd "$@"; }

# --- C Compilation ---
alias ccw='cc -Wall -Wextra -Werror'
alias val='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'

# Switch vers config 42 (Vogsphere)
alias git42='git config user.name "equentin" && git config user.email "equentin@student.42lyon.fr" && echo "Config Git: 42 (Vogsphere)"'

# Switch vers config GitHub Personnel
alias gitperso='git config user.name "Cu-chi" && git config user.email "110144918+Cu-chi@users.noreply.github.com" && echo "Config Git: Perso (GitHub)"'

# Optionnel : Voir la config actuelle
alias gitcheck='git config user.name && git config user.email'

# =============================================================================
#  INTERFACE (Prompt)
# =============================================================================

# Launch Starship
eval "$(starship init zsh)"