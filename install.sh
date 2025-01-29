#!/bin/sh

echo "Welcome to HyprArch"
echo "Installing necessary packages, fonts, and utilities..."

# Install essential packages
sudo pacman -S --noconfirm --needed hyprland xdg-desktop-portal-hyprland dkms reflector rofi dunst fastfetch waybar gdisk xorg-xhost git gnome-polkit vlc sddm network-manager network-manager-applet

# Prompt for LTS Kernel Installation
read -p "Do you want LTS kernels? (y/N): " choice
if [ "$choice" = "y" ]; then
    sudo pacman -S --noconfirm --needed linux-lts linux-lts-headers
else
    echo "Continuing..."
fi

# Function to select and install an AUR helper
select_aur_helper() {
    echo "Select an AUR helper:"
    echo "1. Paru"
    echo "2. Yay"

    read -p "Enter the number corresponding to your choice: " choice

    case $choice in
        1) aur_helper="paru" ;;
        2) aur_helper="yay" ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac

    if ! command -v $aur_helper &> /dev/null; then
        echo "Installing $aur_helper..."
        sudo pacman -S --needed --noconfirm $aur_helper
    fi

    echo "Using: $aur_helper"
}
select_aur_helper

# Function to install fonts
install_fonts() {
    if command -v yay &> /dev/null; then
        aur_helper="yay"
    elif command -v paru &> /dev/null; then
        aur_helper="paru"
    else
        echo "No AUR helper found. Please install Yay or Paru."
        exit 1
    fi

    echo "Using: $aur_helper"
    fonts=(
        ttf-bitstream-vera
        ttf-dejavu
        ttf-liberation
        ttf-nerd-fonts-symbols-mono
        ttf-noto-nerd
        ttf-opensans
        ttf-font-awesome
        ttf-firacode-nerd
        ttf-cascadia-code
        ttf-jetbrains-mono-nerd
    )

    echo "Installing fonts..."
    $aur_helper -S --noconfirm --needed "${fonts[@]}"
    echo "Fonts installation complete!"
}
install_fonts

# Function to select and install a browser
select_browser() {
    echo "Select a browser to install:"
    echo "1. Chromium"
    echo "2. Firefox"
    echo "3. Brave"
    echo "4. Microsoft Edge"

    read -p "Enter the number corresponding to your choice: " choice

    case $choice in
        1) browser="chromium" ;;
        2) browser="firefox" ;;
        3) browser="brave-bin" ;;
        4) browser="microsoft-edge-dev-bin" ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac

    echo "Installing $browser..."
    sudo pacman -S --noconfirm --needed $browser
}
select_browser

# Function to choose and install a shell
shell_choice() {
    echo "Which shell do you want to use:"
    echo "1. Bash (Already installed)"
    echo "2. Zsh (An extended version of the Bourne Shell)"
    echo "3. Fish (A smart and user-friendly command line shell)"

    read -p "Enter the number corresponding to your choice: " response

    case $response in
        1) echo "Exiting."; return 1 ;;
        2) shell="zsh" ;;
        3) shell="fish" ;;
        *) echo "Invalid choice. Exiting."; return 1 ;;
    esac

    sudo pacman -S --needed --noconfirm $shell
    chsh -s /bin/$shell
    echo "Successfully installed and changed to $shell shell."
}
shell_choice

# Function to install NeoVim and optional configurations
install_neovim() {
    echo "Do you want NeoVim as your text editor?"
    echo "1. Yes"
    echo "2. No"

    read -p "Enter the number corresponding to your choice: " response

    case $response in
        1) nvim="neovim" ;;
        2) echo "Skipping NeoVim installation."; return 1 ;;
        *) echo "Invalid choice. Exiting."; return 1 ;;
    esac

    sudo pacman -S --noconfirm --needed $nvim

    echo "Do you want starter packs with NeoVim?"
    echo "1. AstroNvim"
    echo "2. NvChad"
    echo "Press Enter to load NeoVim with default config."

    read -p "Enter your choice: " choice
    case $choice in
        1) git clone --depth 1 https://github.com/AstroNvim/template "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim ;;
        2) git clone https://github.com/NvChad/starter "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim ;;
        *) echo "Neovim with default config." ;;
    esac

    echo "REMINDER: After reboot, open a terminal and type 'nvim' for post-installation setup."
}
install_neovim

# Function to install and configure Starship prompt
starship_prompt() {
    echo "Do you want Starship prompt in your shell?"
    echo "1. Yes"
    echo "2. No"

    read -p "Enter the number corresponding to your choice: " response

    case $response in
        1)
            sudo pacman -S --noconfirm --needed starship
            rsync -av ./starship.toml $HOME/.config

            case $SHELL in
                "/bin/bash") echo 'eval "$(starship init bash)"' >> $HOME/.bashrc ;;
                "/bin/zsh") echo 'eval "$(starship init zsh)"' >> $HOME/.zshrc ;;
                "/bin/fish") echo 'starship init fish | source' >> $HOME/.config/fish/config.fish ;;
            esac
            ;;
        2)
            rm $HOME/.config/starship.toml
            echo "Skipping Starship installation."
            return 1
            ;;
        *) echo "Invalid choice. Exiting."; return 1 ;;
    esac
}
starship_prompt

# Function to set up custom aliases
custom_alias() {
    case $SHELL in
        "/bin/bash")
            echo 'alias vim=nvim' >> $HOME/.bashrc
            echo 'alias vi=nvim' >> $HOME/.bashrc
            ;;
        "/bin/zsh")
            echo 'alias vim=nvim' >> $HOME/.zshrc
            echo 'alias vi=nvim' >> $HOME/.zshrc
            ;;
        "/bin/fish")
            echo 'alias vi "nvim"' >> $HOME/.config/fish/config.fish
            echo 'alias vim "nvim"' >> $HOME/.config/fish/config.fish
            ;;
    esac
}
custom_alias

select_file_manager() {
    echo "Select a file manager to install:"
    echo "1. Thunar (Lightweight and fast)"
    echo "2. Dolphin (Feature-rich and powerful)"

    read -p "Enter the number corresponding to your choice: " choice

    case $choice in
        1) file_manager="thunar thunar-archive-plugin thunar-actions-plugin thunar-volman" ;;
        2) file_manager="dolphin" ;;
        *)
            echo "Invalid choice. Exiting."
            return 1
            ;;
    esac

    echo "Installing $file_manager..."
    sudo pacman -S --noconfirm --needed $file_manager
    echo "$file_manager installation complete!"
}
select_file_manager


# Moving configuration files
echo "--------------------------------- MOVING CONFIG FILES ---------------------------------"

if ! command -v rsync &> /dev/null; then
    echo "rsync not found. Installing..."
    sudo pacman -S --needed --noconfirm rsync
fi

rsync -av ./dunst $HOME/.config/
rsync -av ./fastfetch/ $HOME/.config/
rsync -av ./rofi/ $HOME/.config/
rsync -av ./waybar/ $HOME/.config/
rsync -av ./swaylock/ $HOME/.config/
rsync -av ./xfce4/ $HOME/.config/
rsync -av ./kitty/ $HOME/.config/
rsync -av ./hypr/ $HOME/.config/
rsync -av ./code-flags.conf $HOME/.config
rsync -av ./bin/ $HOME/.local/share

echo "Setup Complete! Please reboot your system for changes to take effect."
