#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
source $HOME/bin/z.sh

if [[ $TERM == xterm* ]] || [[ $TERM == tmux ]]; then
    alias ls='ls --color=auto'
    eval `dircolors ~/.dircolors`
    alias dict='ydcv'
    alias google='proxychains -q googler -n 5 --np -l zh'
    if [ -n "$DISPLAY" ]; then
        export VIRTUAL_ENV_DISABLE_PROMPT=1
        source ~/.bash-powerline.sh
    fi
    export PATH=$PATH:~/bin
    export PATH=$PATH:~/.npm/bin
    source ~/pyenv/mainpy/bin/activate
    # change terminal title as current running command
    # trap 'printf "\033]0;%s\007" "${BASH_COMMAND//[^[:print:]]/}"' DEBUG
fi
