[[ -z $LD_PRELOAD ]] && {
    export LD_PRELOAD
    typeset -T LD_PRELOAD ld_preload :
}

() {

    # got the file?
    if [[ ! -e $ZSH/subs/stderred/build/libstderred.so ]]; then
        # try to create it
        if [[ -e $ZSH/subs/stderred/Makefile ]]; then
            (( $+commands[cmake] && $+commands[gcc] )) || {
                echo -E 'Stderred: Missing cmake or gcc.'
                return
            }

            ( cd $ZSH/subs/stderred && make )

        else
            echo 'Stderred: Missing subrepo.'

        fi
    fi

    # check again: got the file?
    if [[ -e $ZSH/subs/stderred/build/libstderred.so ]]; then
        ld_preload+=( $ZSH/subs/stderred/build/libstderred.so )
        # custom color
        export STDERRED_ESC_CODE=$'\e[38;5;217m'

        # ok, create keybinding
        stderred-toggle() {
            local -a stderred
            (( $+ld_preload[(r)*stderred*] )) && ld_preload=( ${ld_preload:#$ZSH/subs/stderred/build/libstderred.so} ) || ld_preload+=( $ZSH/subs/stderred/build/libstderred.so )

            # evil hack to refresh prompt :)
            for f in $precmd_functions; do
                $f
            done
            zle && zle .reset-prompt
        }
        zle -N stderred-toggle

    fi

} > ${ZSH_DBG:-/dev/null}
