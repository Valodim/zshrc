
# remember all ^X keybindings (like globs)
() {
    local -a ctrlx_bindings
    ctrlx_bindings=( ${(M)${(f)"$(bindkey -L)"}:#bindkey*\^X*} )

    # vi keybindings. awesome :)
    bindkey -v

    # get the ^X bindings back
    for binding in $ctrlx_bindings; do
        "${(Qz)binding[@]}"
    done
}

# bindkey '^A' incarg
bindkey '^A' beginning-of-line
bindkey '^B' accept-and-infer-next-history
bindkey '^E' end-of-line
bindkey '^F' edit-command-line
bindkey '^G' localhist-toggle
bindkey '^H' run-help
bindkey '^X^L' clear-screen
bindkey '^X^V' edit-arg
bindkey '^X^N' inline-ls-lastarg
bindkey '^X^X' copy-to-clipboard
bindkey '^L' inline-ls
bindkey '^M' accept-line-rdate
bindkey '^O' get-line
bindkey '^P' push-line
bindkey '^R' history-incremental-search-backward
bindkey '^T' undo
bindkey '^W' backward-kill-word-match
bindkey '^Y' insert-root-prefix
bindkey '^Z' job-foreground
bindkey . rationalise-dot

bindkey '^Xh' _complete_help
bindkey '^Xd' _complete_debug

# wrap tab completion
bindkey '^I' expand-or-complete-or-cd

bindkey -M menuselect '^N' accept-and-menu-complete
bindkey -M vicmd g vi-goto-word

# ctrl-left & ctrl-right
bindkey '^[Od' backward-word-match
bindkey '^[OD' backward-word-match
bindkey '^[Oc' forward-word-match
bindkey '^[OC' forward-word-match

# ctrl-up and ctrl-down for substring search
bindkey '^[Oa' history-substring-search-up
bindkey '^[Ob' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

bindkey -M viins jj vi-cmd-mode-samepos

# add zle _functions hook arrays
typeset -aH zle_keymap_select_functions
function zle-keymap-select () {
    for f in $zle_keymap_select_functions; "${(@z)f}"
}
zle -N zle-keymap-select

typeset -aH zle_line_init_functions
function zle-line-init () {
    for f in $zle_line_init_functions; "${(@z)f}"
}
zle -N zle-line-init

typeset -aH zle_line_finish_functions
function zle-line-finish () {
    for f in $zle_line_finish_functions; "${(@z)f}"
}
zle -N zle-line-finish

# set some common keys using terminfo or termcap
() {

    local -A key

    # terminfo is the preferred method
    if zmodload zsh/terminfo && (( $+terminfo[smkx] )); then

        zle_line_init_functions+=( 'echoti smkx' )
        zle_line_finish_functions+=( 'echoti rmkx' )

        key[Home]=${terminfo[khome]}
        key[End]=${terminfo[kend]}
        key[Insert]=${terminfo[kich1]}
        key[Delete]=${terminfo[kdch1]}
        key[Backspace]=${terminfo[kbs]}
        key[Up]=${terminfo[kcuu1]}
        key[Down]=${terminfo[kcud1]}
        key[Left]=${terminfo[kcub1]}
        key[Right]=${terminfo[kcuf1]}
        key[PageUp]=${terminfo[kpp]}
        key[PageDown]=${terminfo[knp]}

    elif zmodload zsh/termcap && (( $+termcap[kh] )); then

        key[Home]=${termcap[kh]}
        # wtf?
        key[End]=${termcap[@7]}
        key[Insert]=${termcap[kI]}
        key[Delete]=${termcap[kD]}
        key[Backspace]=${termcap[kb]}
        key[Up]=${termcap[ku]}
        key[Down]=${termcap[kd]}
        key[Left]=${termcap[kl]}
        key[Right]=${termcap[kr]}
        key[PageUp]=${termcap[kN]}
        key[PageDown]=${termcap[kP]}

    # otherwise, just take wild guesses!
    else

        key[Home]='^[[7~'
        key[End]='^[[8~'
        key[Insert]='^[[2~'
        key[Delete]='^[[3~'
        key[Backspace]='^?'
        key[Up]='^[OA'
        key[Down]='^[OB'
        key[Left]='^[OD'
        key[Right]='^[OC'
        key[PageUp]='^[[5~'
        key[PageDown]='^[[6~'

    fi

    # movements
    bindkey "${key[Left]}" backward-char
    bindkey "${key[Right]}" forward-char
    bindkey "${key[Home]}" beginning-of-line
    bindkey "${key[End]}" end-of-line

    # history completion up/down keys
    bindkey "${key[Up]}" history-beginning-search-backward-end
    bindkey "${key[Down]}" irssi-down

    bindkey "${key[Backspace]}" backward-delete-char
    bindkey "${key[Delete]}" delete-char

    bindkey -M menuselect "${key[PageUp]}" accept-and-infer-next-history
    bindkey -M menuselect "${key[PageDown]}" undo

}
