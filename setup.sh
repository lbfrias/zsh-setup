#!/bin/bash

# Helpers
detect_package_manager() {
    if command -v apt-get >/dev/null; then
        echo "apt-get"
    elif command -v dnf >/dev/null; then
        echo "dnf"
    elif command -v yum >/dev/null; then
        echo "yum"
    elif command -v pacman >/dev/null; then
        echo "pacman"
    elif command -v zypper >/dev/null; then
        echo "zypper"
    elif command -v brew >/dev/null; then
        echo "brew"
    elif command -v apk >/dev/null; then
        echo "apk"
    else
        echo "unknown"
    fi
}

install_packages() {
    manager=$(detect_package_manager)

    case "$manager" in
        apt-get)
            sudo apt-get update
            sudo apt-get install -y "${packages[@]}"
            ;;
        dnf|yum)
            sudo "$manager" install -y "${packages[@]}"
            ;;
        pacman)
            sudo pacman -Sy --noconfirm "${packages[@]}"
            ;;
        zypper)
            sudo zypper install -y "${packages[@]}"
            ;;
        brew)
            brew install "${packages[@]}"
            ;;
        apk)
            sudo apk add "${packages[@]}"
            ;;
        *)
            echo "Unsupported package manager. Please install manually."
            ;;
    esac
}

# Install zsh if not present

if command -v zsh >/dev/null 2>&1; then
    echo "✅ zsh is installed at: $(command -v zsh)"
else

    packages=(zsh)
    install_packages
fi

# Install necessary packages
packages=(
    fastfetch
    fzf
    eza
    chafa
    ripgrep

)
install_packages

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install fzf-zsh-plugin
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin

# Install fzf-tab
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

# Copy zshrc
cp .zshrc $HOME/.zshrc

# Copy powerlevel10k config
cp .p10k.zsh $HOME/.p10k.zsh

# Copy fzf config
mkdir -p $HOME/.fzf/shell
fzf --zsh > $HOME/.fzf/shell/key-bindings.zsh
cp .fzf.zsh $HOME/.fzf.zsh
