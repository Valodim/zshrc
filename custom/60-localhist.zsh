ZSH_HIST_DIR=$ZSH/hist/
localhist_chpwd() {
    # go backwards through pwd
    local spwd=$PWD
    while [[ $spwd != "/" ]]; do
        # check if there's a __hist file on each level
        localhist=( $ZSH_HIST_DIR/$spwd/__hist(N:A) )
        # if yes, break, if not, nvm.
        [[ -n $localhist ]] && break || spwd=${spwd:h}
    done

    localhist_refresh
}
add-zsh-hook chpwd localhist_chpwd

# updates the history depending on localhist, localhist_disable, and localhist_current
localhist_refresh() {
    # there is a history, but there shouldn't be or it's not the correct one
    if [[ -n $localhist_current && ( -n $localhist_disable || -z $localhist || $localhist_current != $localhist ) ]]; then
        # pop hist stack and unset localhist
        fc -P
        localhist_current=
    fi

    # there is a localhist, but it's not current
    if [[ -z $localhist_disable && -n $localhist && -z $localhist_current ]]; then
        # set localhist to current
        fc -p $localhist
        localhist_current=$localhist
    fi
}

localhist_create lhc () {
    [[ ! -e $ZSH_HIST_DIR/$PWD ]] && mkdir -p $ZSH_HIST_DIR/$PWD
    touch $ZSH_HIST_DIR/$PWD/__hist

    localhist_chpwd
}

localhist_disable lh0 () {
    localhist_disable=yes
    localhist_refresh
    # evil hack! but otherwise the precmd does not get run to update display
    (( $+functions[valodim_precmd] )) && valodim_precmd
    zle && zle .reset-prompt
    return 0
}

localhist_enable lh1 () {
    localhist_disable=
    localhist_refresh
    # evil hack!
    (( $+functions[valodim_precmd] )) && valodim_precmd
    zle && zle .reset-prompt
    return 0
}

localhist-toggle() {
    [[ -n $localhist_disable ]] && localhist_enable || localhist_disable
}
zle -N localhist-toggle
