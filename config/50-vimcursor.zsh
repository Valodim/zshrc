# change the cursor color with vi mode - only works in rxvt-unicode, afaik

zle-keymap-select () {
    if [[ $TERM == "rxvt-unicode" || $TERM == "rxvt-unicode-256color" ]]; then
        if [ $KEYMAP = vicmd ]; then
            echo -ne "\033]12;Red\007"
        else
            echo -ne "\033]12;Grey\007"
        fi
    fi
}
zle -N zle-keymap-select
zle-line-init () {
    zle -K viins
    if [[ $TERM == "rxvt-unicode" || $TERM = "rxvt-unicode-256color" ]]; then
        echo -ne "\033]12;Grey\007"
    fi
    # echo -n "[?25l"
}
zle -N zle-line-init
