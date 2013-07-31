() {

    export LD_PRELOAD
    typeset -g -U -T LD_PRELOAD ld_preload :
    # get rid of empty elements (I don't know where these comes from...)
    ld_preload=( ${ld_preload:#} )

    local libpath=$ZSH/subs/stderred/build/libstderred.so

    # got the lib?
    if [[ -e $libpath ]]; then
        (( $+ld_preload[(r)$libpath] )) || ld_preload+=( $libpath )

        # custom color, if not already set
        [[ -z $STDERRED_ESC_CODE ]] && export STDERRED_ESC_CODE=$'\e[38;5;217m'

        # ok, create keybinding
        stderred-toggle() {
            local -a stderred
            (( $+ld_preload[(r)$libpath] )) && ld_preload=( ${ld_preload:#$libpath} ) || ld_preload+=( $libpath )

            # evil hack to refresh prompt :)
            for f in $precmd_functions; do
                $f
            done
            zle && zle .reset-prompt
        }
        zle -N stderred-toggle

    fi

} > ${ZSH_DBG:-/dev/null}
