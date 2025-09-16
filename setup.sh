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
            sudo pacman -Sy --needed --noconfirm "${packages[@]}"
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

# Cleanup previous omz and fzf config
rm -rf $HOME/.oh-my-zsh $HOME/.p10k.zsh $HOME/.fzf* $HOME/.zshrc

# Install oh-my-zsh
export RUNZSH="no"
export OVERWRITE_CONFIRMATION="no"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install fzf-zsh-plugin
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin

# Install fzf-tab
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

echo "Linking config files.."

# Copy zshrc
# cp .zshrc $HOME/.zshrc
rm -f $HOME/.zshrc
ln -s $(pwd)/.zshrc $HOME/.zshrc

# Copy powerlevel10k config
#cp .p10k.zsh $HOME/.p10k.zsh
ln -s $(pwd)/.p10k.zsh $HOME/.p10k.zsh

# Copy fzf config
# cp -R .fzf $HOME
ln -s $(pwd)/.fzf $HOME/.fzf
# cp .fzf.zsh $HOME/.fzf.zsh
ln -s $(pwd)/.fzf.zsh $HOME/.fzf.zsh

echo "Installation done!"
