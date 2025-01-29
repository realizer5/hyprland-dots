#!/bin/sh

echo "Welcome to HyprArch"
echo "install needed packages fonts and other utilities"

sudo pacman -S --noconfirm --needed hyprland xdg-desktop-portal-hyprland dkms reflector rofi dunst fastfetch waybar thunar gdisk gnome-polkit

read -p "Do you want LTS kernels y/N" choice 
if ["$choice" == "y"]; then
  sudo pacman -S --noconfirm --needed linux-lts linux-lts-headers
else
  echo "Continuing"
fi

read -p "1.Paru or 2.Yay" choice

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

    echo "You selected: $browser"
    sudo pacman -S --noconfirm --needed $browser
}

select_browser

function shell_choice() {
    echo "Which shell do you want to use :"
    echo "1. bash (Already installed)"
    echo "2. zsh (An extended version of the Bourne Shell)"
    echo "3. fish (A smart and user-friendly command line shell )"

    read -p "Enter the number corresponding to your choice: " response

    case $response in
    1)
        echo "Exiting."
        return 1
        ;;
    2)
        shell="zsh"
        ;;
    3)
        shell="fish"
        ;;
    *)
        echo "Invalid choice. Exiting."
        return 1
        ;;
    esac
    yay -S $shell
    chsh -s /bin/$shell
    echo "Successfully installed and changed to $shell shell."
}
shell_choice


function install_neovim() {
    echo "Do you want NeoVim as text-editor : "
    echo "1. Yes"
    echo "2. No"

    read -p "Enter the number corresponding to your choice: " response

    case $response in
    1)
        nvim="neovim"
        ;;
    2)
        echo "Exiting."
        return 1
        ;;
    *)
        echo "Invalid choice. Exiting."
        return 1
        ;;
    esac

    sudo pacman -S --noconfirm --needed $nvim
    echo "Do you want starter packs with neo vim."
    echo "1. AstroNvim"
    echo "2. NvChad"
    echo "Enter to load neovim with default config."

    read -p ""choice
    case $choice in
    1)
      git clone --depth 1 https://github.com/AstroNvim/template "$XDG_CONFIG_HOME:-$HOME/.config"/nvim
    2)
      git clone https://github.com/NvChad/starter "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim 
    *)
      echo "Neovim with default config."

    echo "REMINDER : After reboot open terminal and type nvim for post installation of neovim"
}
install_neovim


function starship_prompt() {
    echo "Do you want starship prompt in your shell: "
    echo "1. yes"
    echo "2. no"

    read -p "Enter the number corresponding to your choice: " response

    case $response in
    1)
        sudo pacman -S --noconfirm --needed starship

        if [[ $SHELL = "/bin/bash" ]]; then
            echo 'eval "$(starship init bash)"' >>$HOME/.bashrc

        elif [[ $SHELL = "/bin/zsh" ]]; then
            echo 'eval "$(starship init zsh)"' >>$HOME/.zshrc

        elif [[ $SHELL = "/bin/fish" ]]; then
            echo 'starship init fish | source' >>$HOME/.config/fish/config.fish

        fi
        ;;
    2)
        rm $HOME/.config/starship.toml
        echo "Exiting.."
        return 1
        ;;
    *)
        echo "Invalid choice. Exiting."
        return 1
        ;;
    esac
}
starship_prompt


# -------------------------------------
#       setting alias
# -------------------------------------
function custom_alias() {
    if [[ $SHELL = "/bin/bash" ]]; then
        echo 'alias vim = nvim' >>$HOME/.bashrc
        echo 'alias vi = nvim' >>$HOME/.bashrc

    elif [[ $SHELL = "/bin/zsh" ]]; then
        echo 'alias vim = nvim' >>$HOME/.zshrc
        echo 'alias vi = nvim' >>$HOME/.zshrc

    elif [[ $SHELL = "/bin/fish" ]]; then
        echo 'alias vi "nvim"' >>$HOME/.config/fish/config.fish
        echo 'alias vim "nvim"' >>$HOME/.config/fish/config.fish

    fi
}
custom_alias
