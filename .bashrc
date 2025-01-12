#!/usr/bin/env bash
iatest=$(expr index "$-" i)

if [ -f /usr/bin/fastfetch ]; then
	fastfetch --colors-block-range-start 9 --colors-block-width 3
fi

if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
fi

#######################################################
# EXPORTS
#######################################################

# Disable the bell
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi

export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T" # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL="erasedups:ignoredups:ignorespace"

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# set up XDG folders
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Allow ctrl-S for history navigation (with ctrl-R)
[[ $- == *i* ]] && stty -ixon

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias vim='nvim'

# Add an "alert" alias for long running commands.  Use like so:
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#######################################################
# GENERAL ALIAS'S
#######################################################
#pacman alias
alias pacin='sudo pacman -S'
alias pacun='sudo pacman -Rns'
alias pacup='sudo pacman -Syu'
alias paccl='sudo pacman -Sc'
alias pacs='pacman -Ss | grep'
alias pacls='pacman -Q | grep'
alias pacorph='sudo pacman -Qdtq | sudo pacman -Rns -'

#wallpaper change
alias wall='~/.local/share/bin/chwal.sh'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias grep='rg'

#ls alias
alias ls='ls -aFh --color=always' # add colors and file type extensions

# Change directory aliases
alias home='cd ~'
alias ..='cd ..'


# cd into the old directory
alias bd='cd "$OLDPWD"'

 #Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Search command line history
alias h="history | grep "

# Search files in the current folder
alias f="find . | grep "
#######################################################
# SPECIAL FUNCTIONS
#######################################################
# Copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# Create and go to the directory
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}

lazyg() {
	git add .
	git commit -m "$1"
	git push
}

extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*.tar.xz) tar xf $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

cpg() {
	if [ -d "$2" ]; then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

# Move and go to the directory
mvg() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# Automatically do an ls after each cd, z, or zoxide
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}

#personal

react(){
    pnpm create vite "$1" --template react;
    cd "$1";
    pnpm i;
    pnpm i -D tailwindcss postcss autoprefixer;
    pnpx tailwindcss init -p;
    sed -i 's|content: \[\],|content: [\n"./index.html",\n"./src/**/*.{js,ts,jsx,tsx}",\n],|g' "./tailwind.config.js"
    echo -e  "@tailwind base;\n@tailwind components;\n@tailwind utilities;" > "./src/index.css"
}

# Check if the shell is interactive
if [[ $- == *i* ]]; then
    # Bind Ctrl+f to insert 'zi' followed by a newline
    bind '"\C-f":"zi\n"'
fi

export PATH=$PATH:"$HOME/.cargo/bin"

eval "$(starship init bash)"
eval "$(zoxide init bash)"
. "$HOME/.cargo/env"
