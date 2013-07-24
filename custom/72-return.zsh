
# save latest dir we chpwd'd to
return_chpwd() {
    [[ $PWD != $HOME ]] && echo "$PWD" >! $ZSH/.return_pwd
}

autoload -U add-zsh-hook
add-zsh-hook chpwd return_chpwd

function accept-line-return() {
    # reset old accept-line behavior
    bindkey '^M' "${(@)accept_line_reset}"

    # clean up after ourselves
    unfunction accept-line-return
    unset accept_line_reset
    # !! CAUSES SEGFAULT
    # zle -D accept-line-return

    # if buffer is empty, return to last dir
    if [[ -z $BUFFER ]]; then
        retdir=( "$(<$ZSH/.return_pwd)"(N) )
        BUFFER="cd ${(q)retdir}"
    fi

    # repeat accept-line action, this time handled by the old accept-line widget
    zle -U $'\n'

}
zle -N accept-line-return

# remember what ^M is bound to for later
typeset -ha accept_line_reset
accept_line_reset=( ${(z)"$(bindkey '^M')"} )
# remove the first element (that is, '^M')
accept_line_reset[1]=( )
# then override it
bindkey '^M' accept-line-return

