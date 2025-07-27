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

export EDITOR=nvim

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

# ------------------------------ END -------------------------------------#

ff

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"
