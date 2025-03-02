#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ------------------------- LOADING SCRIPTS ------------------------#

if [ -f ~/.bash_functions ]; then
    source ~/.bash_functions
fi


alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# ------------------------- EXPORT -------------------------------#

export PATH="$HOME/.cargo/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NVM_DIR="$HOME/.nvm"
export PATH=$PATH:/sbin
eval "$(starship init bash)"
export EDITOR='nvim'
export ANDROID_HOME=$HOME/Android/Sdk.
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH


# --------------------------- ALIAS ---------------------------------#

alias ..="cd ../.."
alias .="cd .."
alias x="exit"
alias cls="clear"
alias bye="shutdown now"
alias nm="nmtui"
alias fan="sensors | grep fan"
alias v="nvim"
alias vb="nvim .bashrc"
alias ff="fastfetch --kitty-direct ~/.config/fastfetch/eren.png"
alias bm="blendr"

# ------------------------------ finish -------------------------------------#

ff
