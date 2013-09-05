
# this module makes use of the bracketed paste mode supported by both xterm and
# urxvt. basically, it reacts to a specific code sequence, which indicates a
# paste is going to be input, reads the entire paste until the end code, and
# inserts it as a single operation.

# relies on zle_line_init_functions and zle_line_finish_functions being
# appropriately called. see config/70-keymap.zsh

# code mostly stolen from^W^Winspired by Mikachu
# http://www.zsh.org/mla/users/2011/msg00367.html

# create a new keymap to use while pasting
bindkey -N paste
# make everything in this keymap call our custom widget
bindkey -R -M paste "^@"-"\M-^?" paste-insert
# these are the codes sent around the pasted text in bracketed
# paste mode.
bindkey '^[[200~' _start_paste
bindkey -M paste '^[[201~' _end_paste
# insert newlines rather than carriage returns when pasting newlines
bindkey -M paste -s '^M' '^J'


# switch the active keymap to paste mode
function _start_paste() {
    # remember the current keymap
    typeset -agH _paste_oldmap
    _paste_oldmap=( ${(z)"$(bindkey -lL main)"} )
    # set paste keymap (ie, re-alias main to it)
    bindkey -A paste main
    # set up a variable for the pasted content
    typeset -gH _paste_content
}

# go back to our normal keymap, and insert all the pasted text in the
# command line. this has the nice effect of making the whole paste be
# a single undo/redo event.
function _end_paste() {
    # restore keymap using the command we saved before
    "${(@)_paste_oldmap}"

    setopt localoptions extendedglob

    # try to guess if we're inside a quote and if we aren't, escape things that
    # look like urls

    # the LBUFFER expression will try to count non-escaped 's left of the
    # cursor by first removing all \', stripping all other non-' characters,
    # and counting what's left.

    if (( ${#${LBUFFER//\\\'/}//[^\']/} % 2 == 0 )) && [[ $_paste_content == [[:lower:]]#://* ]]; then
        local url_seps url_metas
        zstyle -s ':url-quote-magic:*' url-seps url_seps || url_metas='*?[]^(|)~#{}='
        zstyle -s ':url-quote-magic:*' url-metas url_metas || url_metas=';&<>$'
        # fix these characters a bit so they work in the pattern
        url_metas=${url_metas//\[/\\[}
        url_metas=${url_metas//\]/\\]}
        _paste_content=${_paste_content//(#b)([$~url_metas])/\\$match[1]}
        _paste_content=${_paste_content//(#b)([$~url_seps])/\\$match[1]}
    fi

    LBUFFER+=$_paste_content
    unset _paste_content _paste_oldmap
}

function _paste_insert() {
    _paste_content+=$KEYS
}

# bind widgets to these functions
zle -N _start_paste
zle -N _end_paste
zle -N paste-insert _paste_insert

# request bracketed paste mode only from terminals known to support the
# feature. do this here to support the paste keys either way.

# only if the terminal is known to support bracketed paste
[[ $TERM == rxvt-unicode* || $TERM == xterm* || -n $TMUX ]] || return

# in case of tmux, only versions 1.7 and up
[[ -n $TMUX ]] && [[ ${"$(tmux -V)"#tmux } -lt 1.7 ]] && return

function zle-line-init-bpaste () {
    printf '\e[?2004h'
}

function zle-line-finish-bpaste () {
    printf '\e[?2004l'
}

zle_line_init_functions+=( zle-line-init-bpaste )
zle_line_finish_functions+=( zle-line-finish-bpaste )

