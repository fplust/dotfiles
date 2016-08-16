#!/bin/sh
# export LANG=zh_CN.UTF-8
# export LANGUAGE=zh_CN.UTF-8
# export LC_ALL=zh_CN.UTF-8
# export LC_CTYPE=zh_CN.UTF-8
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export EDITOR=vim
export BROWSER=chromium
/usr/bin/VBoxClient-all
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
fcitx
exec i3

# bspwm
# sxhkd &
# exec bspwm

