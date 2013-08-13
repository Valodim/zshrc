
# this module makes use of the bracketed paste mode supported by both xterm and
# urxvt. basically, it reacts to a specific code sequence, which indicates a
# paste is going to be input, reads the entire paste until the end code, and
# inserts it as a single operation.

# code mostly stolen from^W^Winspired by Mikachu
# http://www.zsh.org/mla/users/2011/msg00367.html

# if this is not rxvt-unicode for xterm, tread no further.
[[ $TERM == rxvt-unicode* || $TERM == xterm* ]] || return 0

# create a new keymap to use while pasting
bindkey -N paste
# make everything in this keymap call our custom widget
bindkey -R -M paste "^@"-"\M-^?" paste-insert
# these are the codes sent around the pasted text in bracketed
# paste mode.
# do the first one with both -M viins and -M vicmd in vi mode
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

function zle-line-init-bpaste () {
    printf '\e[?2004h'
}

function zle-line-finish-bpaste () {
    printf '\e[?2004l'
}

zle_line_init_functions+=( zle-line-init-bpaste )
zle_line_finish_functions+=( zle-line-finish-bpaste )

