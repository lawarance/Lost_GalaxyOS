# ═══════════════════════════════════════════════════════════════════
#  ✦ Lost Galaxy — Git Bash (~/.bashrc)
#  repo: ~/dotfiles/gitbash/.bashrc
# ═══════════════════════════════════════════════════════════════════

# only run the interactive stuff in interactive shells
[[ $- != *i* ]] && return


# ─── 1. bash ──────────────────────────────────────────────────────

# reload / edit this file
alias reload='source ~/.bashrc'
alias editbash='nano ~/.bashrc'
alias codebash='code ~/.bashrc'
alias bashrc='echo ~/.bashrc'
alias bash_profile='echo ~/.bash_profile'

# clear screen
alias c='clear'
alias cl='clear'
alias cls='clear'
alias clean='clear'

# ask before deleting / overwriting / moving
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# make dir + cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }
alias dircd='mkcd'


# ─── 2. navigation ────────────────────────────────────────────────

alias dotfiles='cd ~/dotfiles'
alias home='cd ~/Desktop/Lawarance'
alias prj='cd ~/Desktop/Lawarance/Notes/Sem3/AiDS/AiSD_2026Z_GR2_gr4'


# ─── 3. build tools ───────────────────────────────────────────────

alias make='mingw32-make'


# ─── 4. alacritty / keybinds ──────────────────────────────────────

# Ctrl+Q = clear the whole line (stty frees Ctrl+Q from "resume output")
stty -ixon 2>/dev/null
bind '"\C-q": kill-whole-line'


# ─── 5. fastfetch ─────────────────────────────────────────────────

alias neofetch='fastfetch'
# uncomment to show fastfetch on every new bash window:
# clear && fastfetch


# ─── 6. cli tools (task 5: eza, bat, fzf, btop) ──────────────────

# coming next task


# ─── 7. prompt: starship ─────────────────────────────────────────
# config: ~/.config/starship.toml
# fallback prompt if starship isn't installed

if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
else
  export PS1='\n\[\e[35m\]\w\[\e[0m\]\n\[\e[35m\]</>\[\e[0m\] '
fi


# ─── 8. zoxide (smart cd: `z dotfiles`) ──────────────────────────

command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
