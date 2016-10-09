#!/usr/bin/env bash

__powerline() {

    # Unicode symbols
    readonly PS_SYMBOL_LINUX='$'
    readonly PS_SYMBOL_OTHER='%'
    readonly GIT_BRANCH_SYMBOL=' '
    readonly GIT_BRANCH_CHANGED_SYMBOL='+'
    readonly POWERSHELL_SYMBOL=''
    readonly GIT_NEED_PUSH_SYMBOL='⇡'
    readonly GIT_NEED_PULL_SYMBOL='⇣'
    readonly PYTHON_SYMBOL=' '
    readonly USER_SYMBOL='  '
    readonly NEWLINE='⤶'

    # Solarized colorscheme
    readonly FG_BASE03="\[$(tput setaf 8)\]"
    readonly FG_BASE02="\[$(tput setaf 0)\]"
    readonly FG_BASE01="\[$(tput setaf 10)\]"
    readonly FG_BASE00="\[$(tput setaf 11)\]"
    readonly FG_BASE0="\[$(tput setaf 12)\]"
    readonly FG_BASE1="\[$(tput setaf 14)\]"
    readonly FG_BASE2="\[$(tput setaf 7)\]"
    readonly FG_BASE3="\[$(tput setaf 15)\]"

    readonly BG_BASE03="\[$(tput setab 8)\]"
    readonly BG_BASE02="\[$(tput setab 0)\]"
    readonly BG_BASE01="\[$(tput setab 10)\]"
    readonly BG_BASE00="\[$(tput setab 11)\]"
    readonly BG_BASE0="\[$(tput setab 12)\]"
    readonly BG_BASE1="\[$(tput setab 14)\]"
    readonly BG_BASE2="\[$(tput setab 7)\]"
    readonly BG_BASE3="\[$(tput setab 15)\]"

    readonly FG_YELLOW="\[$(tput setaf 3)\]"
    readonly FG_ORANGE="\[$(tput setaf 9)\]"
    readonly FG_RED="\[$(tput setaf 1)\]"
    readonly FG_MAGENTA="\[$(tput setaf 5)\]"
    readonly FG_VIOLET="\[$(tput setaf 13)\]"
    readonly FG_BLUE="\[$(tput setaf 4)\]"
    readonly FG_CYAN="\[$(tput setaf 6)\]"
    readonly FG_GREEN="\[$(tput setaf 2)\]"

    readonly BG_YELLOW="\[$(tput setab 3)\]"
    readonly BG_ORANGE="\[$(tput setab 9)\]"
    readonly BG_RED="\[$(tput setab 1)\]"
    readonly BG_MAGENTA="\[$(tput setab 5)\]"
    readonly BG_VIOLET="\[$(tput setab 13)\]"
    readonly BG_BLUE="\[$(tput setab 4)\]"
    readonly BG_CYAN="\[$(tput setab 6)\]"
    readonly BG_GREEN="\[$(tput setab 2)\]"

    readonly DIM="\[$(tput dim)\]"
    readonly REVERSE="\[$(tput rev)\]"
    readonly RESET="\[$(tput sgr0)\]"
    readonly BOLD="\[$(tput bold)\]"

    # what OS?
    readonly PS_SYMBOL=$PS_SYMBOL_LINUX

    __git_info() { 
        [ -x "$(which git)" ] || return    # git not found

        local git_eng="env LANG=C git"   # force git output in English to make our work easier

        gitstatus=$( $git_eng status --porcelain --branch 2>/dev/null )
        [[ "$?" -ne 0 ]] && return  # git branch not found

        while IFS='' read -r line || [[ -n "$line" ]]; do
            status=${line:0:2}
            case "$status" in
                \#\#) branch_line="${line/\.\.\./^}" ;;
                *) marks+=" $GIT_BRANCH_CHANGED_SYMBOL"  ;;
            esac
            [ -n "$marks" ] && break
        done <<< "$gitstatus"

        IFS="^" read -ra branch_fields <<< "${branch_line/\#\# }"
        branch="${branch_fields[0]}"

        if [[ "$branch" == *"Initial commit on"* ]]; then
            IFS=" " read -ra fields <<< "$branch"
            branch="${fields[3]}"
        elif [[ "$branch" == *"no branch"* ]]; then
            tag=$( $git_eng describe --tags --exact-match 2>/dev/null )
            if [[ -n "$tag" ]]; then
                branch="$tag"
            else
                branch="$( $git_eng rev-parse --short HEAD 2>/dev/null )"
            fi
        else
            if [[ "${#branch_fields[@]}" -ne 1 ]]; then
                IFS="[,]" read -ra remote_fields <<< "${branch_fields[1]}"
                for remote_field in "${remote_fields[@]}"; do
                    if [[ "$remote_field" == *ahead* ]]; then
                        num_ahead=${remote_field:6}
                        marks+=" $GIT_NEED_PUSH_SYMBOL$num_ahead"
                    fi
                    if [[ "$remote_field" == *behind* ]]; then
                        num_behind=${remote_field:7}
                        marks+=" $GIT_NEED_PULL_SYMBOL$num_behind"
                    fi
                done
            fi
        fi

        # print the git branch segment without a trailing newline
        printf " $GIT_BRANCH_SYMBOL$branch$marks "
    }

    virtualenv_info(){
        # Get Virtual Env
        if [[ -n "$VIRTUAL_ENV" ]]; then
            # Strip out the path and just leave the env name
            venv="${VIRTUAL_ENV##*/}"
        else
        # In case you don't have one activated
            venv=''
        fi
        printf "$venv"
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly. 
        if [ $? -eq 0 ]; then
            local BG_EXIT="$BG_GREEN"
        else
            local BG_EXIT="$BG_RED"
        fi

        local venv="$(virtualenv_info)"
        if [ -z "$venv" ]; then
            PS1="$venv"
        else
            PS1="$BG_BASE02$FG_BASE3$PYTHON_SYMBOL$venv$BG_CYAN$FG_BASE02$POWERSHELL_SYMBOL$RESET"
        fi

        PS1+="$BG_CYAN$FG_BASE3$USER_SYMBOL\u$BG_BASE1$FG_CYAN$POWERSHELL_SYMBOL$RESET"
        local git_info=$(__git_info)
        if [ -z "$git_info" ]; then
            PS1+="$BG_BASE1$FG_BASE3 \w $BG_BASE03$FG_BASE1$POWERSHELL_SYMBOL\n$RESET"
        else
            PS1+="$BG_BASE1$FG_BASE3 \w $BG_BLUE$FG_BASE1$POWERSHELL_SYMBOL$RESET"
            PS1+="$BG_BLUE$FG_BASE3$git_info$BG_BASE03$FG_BLUE$POWERSHELL_SYMBOL\n$RESET"
        fi
        PS1+="$BG_EXIT$FG_BASE3 $PS_SYMBOL $RESET "
    }

    set_prompt() {
        # set PS1...
        ps1
        
        # CSI 6n reports the cursor position as ESC[n;mR, where n is the row
        # and m is the column. Issue this control sequence and silently read
        # the resulting report until reaching the "R". By setting IFS to ";"
        # in conjunction with read's -a flag, fields are placed in an array.
        local curpos
        echo -en '\033[6n'
        IFS=';' read -s -d R -a curpos
        (( curpos[1] > 1 )) && echo "$NEWLINE"
    }

    PROMPT_COMMAND=set_prompt
}

__powerline
unset __powerline
