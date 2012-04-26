# tmux stuff
function ztmux-split-vertical() {
    # are we even inside a screen/tmux? if so, just return
    [[ $TERM == *screen* ]] && return

    # this does not work with multiline editing, but I don't use that anyways
    BUFFER=" tmux new-session 'ZSH_INIT_BUFFER=\"'${(q)BUFFER}'\" exec zsh' \; split-window -d -h"
    zle accept-line
}
# we call it ztmux to avoid completion clashes
zle -N ztmux-split-vertical

# tmux stuff
function ztmux-split-horizontal() {
    # are we even inside a screen/tmux? if so, just return
    [[ $TERM == *screen* ]] && return

    BUFFER=" tmux new-session 'ZSH_INIT_BUFFER=\"'${(q)BUFFER}'\" exec zsh' \; split-window -d -v"
    zle accept-line
}
# we call it ztmux to avoid completion clashes
zle -N ztmux-split-horizontal

bindkey '`v' ztmux-split-vertical
bindkey '`s' ztmux-split-horizontal
