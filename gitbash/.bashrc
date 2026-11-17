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


# ─── 6. cli tools: eza · bat · fzf · btop · lazygit ──────────────

# eza (ls with icons; colors come from the alacritty palette)
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons --git-ignore'

# bat (cat with syntax colors)
export BAT_CONFIG_PATH="$HOME/dotfiles/bat/config"
alias cat='bat'

# fzf (fuzzy finder) — lost galaxy colors
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS=" \
  --height=45% --layout=reverse --border=rounded --margin=0,1 \
  --prompt='󰙴 ' --pointer='▶' --marker='✦' --separator='─' --scrollbar='│' \
  --color=bg:-1,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4 \
  --color=hl:#f5c2e7,hl+:#f5c2e7,info:#cba6f7,prompt:#cba6f7 \
  --color=pointer:#f5e0dc,marker:#b4befe,spinner:#f5e0dc,header:#89dceb \
  --color=border:#45475a,label:#cba6f7,selected-bg:#45475a"

# fp = find file with preview · fe = find + open in code
alias fp="fzf --preview 'bat --color=always --style=numbers --line-range=:200 {}'"
fe() { local f; f=$(fp) && [ -n "$f" ] && code "$f"; }

# Ctrl+T = insert file path · Ctrl+R = fuzzy history · Alt+C = cd into dir
command -v fzf &>/dev/null && eval "$(fzf --bash 2>/dev/null)"

# btop / lazygit
alias top='btop'
alias lg='lazygit'


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
