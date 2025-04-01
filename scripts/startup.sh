#!/usr/bin/env bash

arch_check() {
    if [[ ! -e /etc/arch-release ]]; then
        echo -ne "ERROR! This script must be run in Arch Linux!\n"
        exit 0
    fi
}

pacman_check() {
    if [[ -f /var/lib/pacman/db.lck ]]; then
        echo "ERROR! Pacman is blocked."
        echo -ne "If not running remove /var/lib/pacman/db.lck.\n"
        exit 0
    fi
}

background_checks () {
    arch_check
    pacman_check
}

# starting functions
background_checks

sudo pacman -S --needed $(cat $SCRIPTS_DIR/package.lst)

echo -ne "
----------------------------------------------------------------------------------------------
                                    Movig Config Files
----------------------------------------------------------------------------------------------
"

mv $CONFIGS_DIR/* ~/.config/
