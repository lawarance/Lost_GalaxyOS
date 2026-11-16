export PS1='\n\[\e[33m\]\w\[\e[31m\]`__git_ps1`\[\e[0m\]\n\[\e[32m\]</>\[\e[0m\] '


# Aliasy dla czyszczenia terminala
alias c='clear'
alias cl='clear'
alias cls='clear'
alias clear='clear'
alias clean='clear'

# custom commands 
# to update .bashrc without restarting terminal
alias reload='source ~/.bashrc' 
alias editbash='code ~/.bashrc'

# to prompt before deleting, overwriting and moving files 
alias rm='rm -i' 
alias cp='cp -i' 
alias mv='mv -i' 

# quick navigation to project directory
alias config='cd ~/Desktop/Lawarance/Config_backups'
alias home='cd ~/Desktop/Lawarance'

# use make instead of mingw32-make
alias make='mingw32-make'

# to display the path of .bashrc file
alias bashrc='echo ~/.bashrc'
alias bash_profile='echo ~/.bash_profile'

# quick navigation
alias prj='cd ~/Desktop/Lawarance/Notes/Sem3/AiDS/AiSD_2026Z_GR2_gr4'

# create and enter directory
dircd() {
  mkdir -p "$1" && cd "$1"
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}

alias neofetch='fastfetch'

eval "$(oh-my-posh init bash --config "$HOME/.config/ohmyposh/catppuccin_mocha.omp.json")"