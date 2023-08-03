

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias c='clear'
alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias conda='micromamba'
alias cp='cp -v'
alias df='df -h'
alias du='du -ch'
alias g='git status'
alias ga='git add -A'
alias gc='git commit -a'
alias gd='git pull'
alias gl='git log --oneline -n 10'
alias grep='grep --color=auto'
alias gu='git push'
alias lab='cd ~/lab'
alias ll='ls -lAh --color=auto'
alias ls='ls --color=auto'
alias mm='micromamba'
alias mv='mv -v'
alias mx='chmod +x'
alias q='exit'
alias rm='rm -Iv --preserve-root'
alias scratch='cd ~/lab/_env/scratchpad'
alias ta='tmux attach -t'
alias tc='tmux new-session -t'
alias tk='tmux kill-session -t'
alias tl='tmux ls'
alias tn='tmux new-session -s'
alias v='nvim'


# ==================================================
# COMMON SHELL CAPABILITIES (interactive shell)
# ==================================================

# every time we change directories, ls, because I always do that anyway.
function cd {
    builtin cd "$@" && ls -F
}

function irisdir {
  if [[ -e "/etc/iris/configlocation" ]]; then
    config_location=$(cat "/etc/iris/configlocation")
  fi
  if [[ -e "${XDG_DATA_HOME-$HOME/.local/share}/iris/configlocation" ]]; then
    config_location=$(cat "${XDG_DATA_HOME-$HOME/.local/share}/iris/configlocation")
  fi
  cd "${config_location}"
}

# allow running scripts in current directory without needing ./
export PATH=.:$PATH

# import additional files if we have them

# if we have any quick and dirty path additions, place here
[[ -f ${HOME}/.shell_additional_path ]] && . "${HOME}/.shell_additional_path"
# if we have a fun homescreen like printing a logo, that can go here :)
[[ -f ${HOME}/.home ]] && . "${HOME}/.home"

# ==================================================
# BASH SPECIFIC STUFF (interactive shell)
# ==================================================

# prepare colors
# NOTE: the \001 and \002 are from https://unix.stackexchange.com/a/447520
# without, the bash line doesn't wrap correctly
readonly ta_none="\001$(tput sgr0 2> /dev/null || true)\002"
readonly ta_bold="\001$(tput bold 2> /dev/null || true)\002"
readonly fg_blue="\001$(tput setaf 4 2> /dev/null || true)\002"
    
# nice prompt
PS1="[${fg_blue}\t${ta_none}] ${fg_blue}\u${ta_normal}@${fg_blue}${ta_bold}\h${ta_none}${fg_blue} \w${ta_none} $ " 


# if we have a quick and dirty bashrc addition:
[[ -f ${HOME}/.bashrc_local ]] && . "${HOME}/.bashrc_local"

# >>> mamba initialize >>>
export MAMBA_EXE=$HOME/.local/bin/micromamba
export MAMBA_ROOT_PREFIX=$HOME/micromamba
__mamba_setup="$($MAMBA_EXE shell hook --shell bash --prefix $MAMBA_ROOT_PREFIX 2> /dev/null)"
if [ $? -eq 0 ]; then 
    eval "$__mamba_setup"
else
    if [ -f "${HOME}/micromamba/etc/profile.d/micromamba.sh" ]; then
        . "${HOME}/micromamba/etc/profile.d/micromamba.sh"
    else
        export  PATH="${HOME}/micromamba/bin:$PATH"
    fi
fi
unset __mamba_setup
# <<< mamba initialize <<<

# NOTE: Needed because of the change in 1.2.0: https://github.com/mamba-org/mamba/pull/2137/files
# for whatever reason though __mamba_exe doesn't seem to exist? I determined
# that manually making a function for it that just calls $MAMBA_EXE (like
# what the completion used to do) seems to work fine though:
__mamba_exe () {
  $MAMBA_EXE "$@"
}

if test -n "$KITTY_INSTALLATION_DIR"; then
  source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi

