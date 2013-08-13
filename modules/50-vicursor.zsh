
# change the cursor color with vi mode, not widely tested but works on a few
# setups at least...

# relies on zle_keymap_select_functions being run properly.

if [[ $TERM == rxvt* || $TERM == xterm* || -n $TMUX ]]; then

    # this is a fairly new tmux feature
    [[ -n $TMUX ]] && [[ ${"$(tmux -V)"#tmux } -lt 1.8 ]] && return

    # note for tmux in rxvt-unicode this requires this addition to terminal-overrides:
    # 'rxvt-unicode*:Cc=\E]12;%p1%s\E\\'

    zle-keymap-select-vicursor () {
        if [[ $KEYMAP == vicmd ]]; then
            echo -ne "\033]12;red\033\\"
        else
            echo -ne "\033]12;grey\033\\"
        fi
    }

    zle_keymap_select_functions+=( zle-keymap-select-vicursor )
    # make sure it's correct at the beginning, too!
    zle_line_init_functions+=( zle-keymap-select-vicursor )

fi
