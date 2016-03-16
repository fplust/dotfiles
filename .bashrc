#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -n "$DISPLAY" ]; then
    alias ls='ls --color=auto'
    eval `dircolors ~/.dircolors`
    alias dict='ydcv'
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    source ~/.bash-powerline.sh
    source ~/pyenv/mainpy/bin/activate
fi
source $HOME/bin/z.sh
