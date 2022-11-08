# Time-stamp: <2022-05-07 08:09:55 zshuang>
# bindkey -e # emacs mode, in case of emergency...
setopt local_options local_traps \
    prompt_subst hist_verify \
    inc_append_history hist_ignore_all_dups hist_ignore_space \
    hist_no_store hist_no_functions
# power user, ain't me
setopt auto_cd extended_glob multios autopushd
# use programmable completion, and enable menu selection
autoload -U compinit && compinit
zstyle ':completion:*' menu select=3

#bindkey -M menuselect '^o' accept-and-infer-next-history
# save some history
SAVEHIST=1000
HISTSIZE=1000
HISTFILE=~/.history

# set the prompt
autoload colors
colors

# prompts
if [[ $TERM == "dumb" ]]; then	# in emacs
    PS1='%(?..[%?])%!:%~%# '
    # for tramp to not hang, need the following. cf:
    # http://www.emacswiki.org/emacs/TrampMode
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
else
    ## reset="%{`color off`%}"
    ## perr="$reset%{`color ltred`%}%(?..[%?])"
    ## phist="$reset%B%!%b:"
    ## ppwd="$reset%{`color ltblue`%}%~"
    ## PS1="$perr$phist$ppwd%#$reset "
    ## RPS1="%{`color ltgreen`%}%m${reset}[%l]"
    reset="%{$reset_color%}"
    perr="$reset%{$fg_bold[red]%}%(?..[%?])"
    phist="$reset%B%!%b:"
    ppwd="$reset%{$fg_bold[blue]%}%~"
    PS1="$perr$phist$ppwd%#$reset "
    RPS1="%{$fg_bold[green]%}%m${reset}[%l]"
    unset reset perr ppwd phist
fi

if [[ -n `uname -a | grep Microsoft` ]]; then # in WSL
    unsetopt beep # disable term beeping
fi

# paths
path=(~zshuang/bin ~zshuang/.local/bin /usr/local/bin $path)
#cdpath=(~zshuang/doc/essential ~zshuang/doc/essential/courses)
#cdpath=(~zshuang/doc/research ~zshuang/doc/notes/tex)
cdpath=(~zshuang/proj ~zshuang/bin)
#hash -d essential=~zshuang/doc/essential
#hash -d courses=~essential/courses
#hash -d tex=~/notes/_tex
#hash -d paper=~/doc/essential/paper
hash -d research=~zshuang/doc/research
hash -d notes=~zshuang/doc/notes/tex
# distcc and ccache
#path=(/usr/lib/ccache/bin /usr/lib/distcc/bin $path)
typeset -T INFOPATH infopath
infopath=(~zshuang/info /usr/local/info /usr/share/info $infopath)
typeset -U path infopath
export PATH INFOPATH

export PAGER=most
export PERL_DOC_PAGER="less -+C -E"
export VISUAL=et
export EDITOR=et
export SCREENDIR=$HOME/.screen

## WSL stuff
# -z tests if a variable is of zero length. 
# Set X related variables only if running locally
#if [ -z $SSH_CLIENT ] && [ -z $SSH_TTY ] && [ -z $DISPLAY ]; then
#  export DISPLAY=:0
#  #export LIBGL_ALWAYS_INDIRECT=1
#fi
## set DISPLAY only if it is not set (when shell is invoked in an SSH session, DISPLAY should have been properly set
#export DISPLAY=${DISPLAY:=127.0.0.1:0}

## WSL 2
# Windows 11 has its own X server for WSL2. There is no need to set
# DISPLAY to if you want to use that. However, you won't be able to do
# window snapping (e.g., win + left arrow). To use e.g. X410 as your X
# server, we need the following. See https://stackoverflow.com/questions/61110603/how-to-set-up-working-x11-forwarding-on-wsl2
export DISPLAY=`ip route list default | cut -d' ' -f3`:0


autoload -U select-word-style
select-word-style bash

# dir colors
#if [[ -f ~/.dir_colors ]]; then
#	eval `dircolors -b ~/.dir_colors`
#else
#	eval `dircolors -b /etc/DIR_COLORS`
#fi

# alias
[[ -r ~zshuang/.aliasrc ]] && . ~zshuang/.aliasrc

# emacs vterm
[[ -r ~zshuang/.emacs-vterm-zsh.sh ]] && . ~zshuang/.emacs-vterm-zsh.sh

# when cw

# list kernel modules https://bbs.archlinux.org/viewtopic.php?id=134393
fkm() {
    find /lib/modules/$(uname -r)/ -iname "*$1*.ko*" -exec basename {} .ko.gz \;

    if [[ "$(uname -r)" != "$(/bin/ls -1 /lib/modules/ | head -1)" ]]; then
        echo "Did you reboot after updating your kernel?"
    fi
}

# SPARK stuff
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/zshuang/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/zshuang/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/zshuang/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/zshuang/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
# conda deactivate # so we don't look at "(base)" all the time
