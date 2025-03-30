#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ------------------------- LOADING SCRIPTS ------------------------#

if [ -f ~/.bash_functions ]; then
  source ~/.bash_functions
fi

if [ -f ~/.bash_alias ]; then
  source ~/.bash_alias
fi

# ----------------------------------------------------------------#

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# ------------------------- EXPORT -------------------------------#

export PATH="$HOME/.cargo/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
export NVM_DIR="$HOME/.nvm"
export PATH=$PATH:/sbin
eval "$(starship init bash)"
export EDITOR='nvim'
export ANDROID_HOME=$HOME/Android/Sdk.
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH

# ------------------------------ finish -------------------------------------#

ff
