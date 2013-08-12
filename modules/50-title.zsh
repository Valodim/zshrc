
# try to give the window a meaningful title, at least some of the time

# run some application, maybe?
title-preexec () {
    local -a buf
    buf=( ${(z)1} )

    # straight from zsh-syntax-highlighting :)
    precommands=( 'builtin' 'command' 'exec' 'nocorrect' 'noglob' 'sudo' 'time' )

    # first is a precommand? shift dis shit.
    local prefix
    if (( $+precommands[(r)$buf[1]] )); then
        if [[ $buf[1] == sudo ]]; then

            # show sudo as a prefix
            prefix="sudo "

            # shift away all sudo-args, so the next one should be the command
            shift buf
            while [[ $buf[1] == -* ]]; do
                shift buf
            done

        else
            shift buf
        fi
    fi

    # only care for a couple of command-type types. "for" is hardly a useful title
    local typ=${"$(LC_ALL=C builtin whence -w $buf[1] 2>/dev/null)"#*: }
    [[ $typ == "function" || $typ == "command" || $typ == "alias" ]] || return

    # set the title
    print -nR $'\033]0;'"$prefix${buf[1]:t} (${(D)PWD})"$'\007'
    # is this screen or tmux? set tab title there, too
    if [[ $TERM == screen* ]]; then
        print -nR $'\033k'"$prefix${buf[1]:t}"$'\033\\'
    fi

}

# back to the prompt
title-precmd () {
    print -nR $'\033]2;'"zsh (${(D)PWD})"$'\007'
    if [[ $TERM == screen* ]]; then
        print -nR $'\033k'"zsh"$'\033\\'
    fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec title-preexec
add-zsh-hook precmd title-precmd

