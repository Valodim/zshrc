# tmux stuff
function ztmux-split-vertical() {
    # are we even inside a screen/tmux? if so, just return
    [[ $TERM == *screen* ]] && return

    # we set this, since it's an exec anyways we don't care further :P
    setopt norcquotes
    # this does not work with multiline editing, but I don't use that anyways
    BUFFER=" tmux new-session 'ZSH_INIT_BUFFER=\"'${(qq)BUFFER}'\" exec zsh' \; split-window -d -h"
    zle accept-line
}
# we call it ztmux to avoid completion clashes
zle -N ztmux-split-vertical

# tmux stuff
function ztmux-split-horizontal() {
    # are we even inside a screen/tmux? if so, just return
    [[ $TERM == *screen* ]] && return

    # we set this, since it's an exec anyways we don't care further :P
    setopt norcquotes
    # this does not work with multiline editing, but I don't use that anyways
    BUFFER=" tmux new-session 'ZSH_INIT_BUFFER=\"'${(qq)BUFFER}'\" exec zsh' \; split-window -d -v"
    zle accept-line
}
# we call it ztmux to avoid completion clashes
zle -N ztmux-split-horizontal

# tmux stuff
function ztmux-new-session() {
    # are we even inside a screen/tmux? if so, just return
    [[ $TERM == *screen* ]] && return

    # we set this, since it's an exec anyways we don't care further :P
    setopt norcquotes
    # this does not work with multiline editing, but I don't use that anyways
    BUFFER=" exec tmux new-session 'ZSH_INIT_BUFFER=\"'${(qq)BUFFER}'\" exec zsh'"
    zle accept-line
}
# we call it ztmux to avoid completion clashes
zle -N ztmux-new-session

bindkey '`v' ztmux-split-vertical
bindkey '`s' ztmux-split-horizontal
bindkey '`c' ztmux-new-session
