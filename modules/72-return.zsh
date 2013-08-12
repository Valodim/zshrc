
typeset -H ZSH_RETURN_FILE=${ZSH:-$HOME}/.zsh_return

# save latest dir we chpwd'd to
return_chpwd() {
    [[ $PWD != $HOME ]] && echo -E "$PWD" >! $ZSH_RETURN_FILE
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

    # if buffer is empty, and return file exists, return to last dir
    if [[ -z $BUFFER ]]; then
        # complain if we can't go there
        if [[ ! -f $ZSH_RETURN_FILE ]]; then
            zle -M "No return directory file!"
            return
        fi

        retdir=( "$(<$ZSH_RETURN_FILE)"(N) )
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

