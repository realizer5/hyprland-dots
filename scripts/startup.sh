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


echo -ne "
----------------------------------------------------------------------------------------------
                                    Movig Config Files
----------------------------------------------------------------------------------------------
"

cp $CONFIGS_DIR/* ~/.config/
cp $SCRIPTS_DIR/* ~/.local/

echo -ne "
----------------------------------------------------------------------------------------------
                                    Config Completed
----------------------------------------------------------------------------------------------
"
