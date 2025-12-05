# 🚀 Ultimate 42 Dotfiles

![Badge](https://img.shields.io/badge/OS-Ubuntu-orange) ![Badge](https://img.shields.io/badge/Shell-Zsh-blue) ![Badge](https://img.shields.io/badge/Style-Starship-yellow)

A highly optimized, fast, and productive environment tailored for **42 School** workstations (Ubuntu/GNOME).
Designed to work **without root (sudo) privileges**, with a focus on speed, aesthetics, and modern tools.

![Screenshot](https://raw.githubusercontent.com/Cu-chi/dotfiles/refs/heads/master/preview.png)
## ✨ Features

* **⚡️ Blazing Fast Shell:** Powered by **Zinit** (Turbo mode) and **Zsh**.
* **🎨 Beautiful Prompt:** **Starship** configuration with Git status, execution time, and error codes.
* **🦀 Rust Power:** Auto-installation of modern replacements for standard tools:
    * `ls` -> **`eza`** (Icons, tree view, git integration).
    * `cat` -> **`bat`** (Syntax highlighting, line numbers).
    * `grep` -> **`ripgrep`** (Lightning fast search).
* **🔍 Fuzzy Finding:** Pre-configured **`fzf`** for history and file search.
* **🛠 42 Specifics:**
    * Aliases `cc` flags, `valgrind`.
    * Ready for `francinette` (paco).
    * NFS optimization (Lazy loading for NVM and completion).
* **🏗 Automated Install:** One script to install **Rust**, **Nerd Fonts**, binaries, and symlink everything.

## 📦 Installation

This setup is non-destructive. It backs up your existing configuration files before linking new ones.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Cu-chi/dotfiles.git ~/dotfiles
    ```

2.  **Run the install script:**
    ```bash
    cd ~/dotfiles
    chmod +x install.sh
    ./install.sh
    ```

3.  **Restart your shell:**
    ```bash
    exec zsh
    ```

*Note: The first installation might take a few minutes as it compiles tools like `eza` and `bat` using Cargo.*

## ⌨️ Cheat Sheet

### 🚀 Navigation (FZF)
| Shortcut | Action |
| :--- | :--- |
| `Ctrl` + `R` | **History Search** - Find past commands instantly. |
| `Ctrl` + `T` | **File Search** - Find files in the current folder + preview. |
| `Alt` + `C` | **Directory Search** - Jump to a folder instantly. |
| `**` + `Tab` | **Trigger** - Use FZF inside any command (e.g., `vim src/**<Tab>`). |

### ⚡️ Aliases
| Alias | Command | Description |
| :--- | :--- | :--- |
| `ll` / `la` | `eza -l` / `-la` | List files with icons and git status. |
| `cat` | `bat` | Read file with syntax highlighting. |
| `cc` | `cc -Wall -Wextra -Werror` | Compile with 42 flags. |
| `val` | `valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes` | Run Valgrind with full leak check. |
| `paco` | `~/francinette/tester.sh` | Run Francinette tester (if installed). |
| `c` | `clear` | Clear terminal. |

## 📂 Structure

* `install.sh`: The magic script. Installs Rust, Fonts, Tools, and links configs.
* `zshrc`: The brain of the shell. Zinit plugins, aliases, and optimizations.
* `starship.toml`: Configuration for the prompt style.
* `alacritty.toml`: Configuration for the Alacritty terminal (GPU accelerated).

## 🔧 Customization

* **Alacritty:** Edit `~/dotfiles/alacritty.toml` to change font size or opacity.
* **Zsh:** Edit `~/dotfiles/zshrc` to add your own aliases.
* **Starship:** Edit `~/dotfiles/starship.toml` to change prompt colors/symbols.

## 🤝 Contributing

Feel free to fork this repository and customize it for your own needs. If you find a bug or have an optimization idea for the 42 clusters, PRs are welcome!
