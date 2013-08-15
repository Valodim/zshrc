
# try to give the window a meaningful title, at least some of the time

# use terminfo data to set title. this works with urxvt and probably others
title-set-terminfo () {
    print -nR "$terminfo[tsl]$1 ${*[2,$]}$terminfo[fsl]"
}
# xterm doesn't work with terminfo -> special treatment
title-set-xterm () {
    print -nR $'\033]0;'$1 ${*[2,$]}$'\007'
}

# set tab title in screen
title-set-screen () {
    # tab title only uses $1
    print -nR $'\033k'$1$'\033\\'
}

# run some application, maybe? set title to "command (pwd)"
title-preexec () {

    # don't bother if nopony's listening anyways
    (( $#title_functions > 0 )) || return

    local -a buf
    buf=( ${(z)1} )

    # straight from zsh-syntax-highlighting :)
    precommands=( 'builtin' 'command' 'exec' 'nocorrect' 'noglob' 'sudo' 'time' )

    # first is a precommand? shift dis shit.
    local prefix
    while (( $+precommands[(r)$buf[1]] )); do
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
    done

    # only care for a couple of command-type types. "for" is hardly a useful title
    local typ=${"$(LC_ALL=C builtin whence -w $buf[1] 2>/dev/null)"#*: }
    [[ $typ == "function" || $typ == "command" || $typ == "alias" ]] || return

    local f
    for f in $title_functions; do
        $f "$prefix${buf[1]:t}" "(${(D)PWD})"
    done

}

# back to the prompt, title is "zsh (pwd)"
title-precmd () {

    local f
    for f in $title_functions; do
        $f zsh "(${(D)PWD})"
    done

}

# array of functions to call for title setting
typeset -aH title_functions

# if we can get tsl from terminfo, that'd be perfect. works with urxvt.
zmodload zsh/terminfo
if (( $+terminfo[tsl] && $+terminfo[fsl] )); then
    title_functions+=( title-set-terminfo )
# otherwise, fallback for specific terminals (maybe expand this list?)
elif [[ $TERM == xterm* ]]; then
    title_functions+=( title-set-xterm )
fi

# set screen title independently
if [[ $TERM == screen* ]]; then
    title_functions+=( title-set-screen )
fi

# we do this regardless, to always provide title_functions functionality
autoload -U add-zsh-hook
add-zsh-hook preexec title-preexec
add-zsh-hook precmd title-precmd

