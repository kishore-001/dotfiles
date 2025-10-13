# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ------------------------- LOADING SCRIPTS ------------------------#

[ -f ~/.bash_functions ] && source ~/.bash_functions
[ -f ~/.bash_alias ] && source ~/.bash_alias

# ------------------------- ALIASES -------------------------------#

alias grep='grep --color=auto'

# ------------------------- PROMPT -------------------------------#

PS1='[\u@\h \W]\$ '

# ------------------------- ENVIRONMENT --------------------------#


export FZF_DEFAULT_OPTS='
  --color=bg:#0a0f1f,bg+:#111a33,fg:#c8d3f5,fg+:#ffffff
  --color=hl:#82aaff,hl+:#89ddff,info:#a6accd,prompt:#89ddff,pointer:#ff757f,marker:#c3e88d,spinner:#82aaff
  --border=rounded --layout=reverse --height=65% --prompt="❯ " --margin=1,2 --padding=0,1
'

export EDITOR=nvim
export VISUAL=nvim


# PATH Setup
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:/sbin"
export PATH="$PATH:$(go env GOPATH)/bin"
export PATH="$HOME/.wasmtime/bin:$PATH"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Pyenv (should be in .bash_profile, but included here for now)
eval "$(pyenv init -)"

# Starship prompt
eval "$(starship init bash)"

eval "$(zoxide init bash)"


eval "$(github-copilot-cli alias -- bash)"





# ------------------------------ END -------------------------------------#

ff
