ex-norm () {

    # customized read-from-minibuffer
    () {

        local pos=$[ $#PREDISPLAY + $#LBUFFER ]
        # regular buffer is uninteresting for now.
        # show a space if RBUFFER is empty, otherwise there will be nothing to underline
        local pretext="$PREDISPLAY$LBUFFER${RBUFFER:- }$POSTDISPLAY
"
        local +h LBUFFER=""
        local +h RBUFFER=""
        local +h PREDISPLAY="${pretext}:normal! "
        local +h POSTDISPLAY=

        # underline the cursor position position, and highlight some stuff
        local +h -a region_highlight
        region_highlight=( "P$pos $[pos+1] underline" "P${#pretext} ${#PREDISPLAY} bold")

        # prevent zsh_syntax_highlighting from screwing up our region_highlight
        # not sure if this works with vanilla zsh_syntax_highlight...
        local ZSH_HIGHLIGHT_MAXLENGTH=0

        zle recursive-edit -K main
        stat=$?
        (( stat )) || REPLY=$BUFFER

        return $stat
    } && [[ -n $REPLY ]] || return 1

    # if we have a non-empty $REPLY, process with ex
    () {

        # this might be possible using only stdin/stdout like this
        # $(ex +ponyswag +%p - <<< $BUFFER)
        # but we play it safe using a temp file here.

        local -a posparams
        (( CURSOR > 0 )) && posparams=( +'set ww+=l ve=onemore' +"normal! gg${CURSOR}l" +'set ww-=l ve=' )

        # call ex in silent mode, move $CURSOR chars to the right with proper
        # wrapping, run the specified command in normal mode, prepend position
        # of the new cursor, write and exit.
        ex -s $posparams \
            +"normal! $1" \
            +"let @a=col('.')" \
            +'normal! ggi ' \
            +'normal! "aP' \
            +wq "$2"

        result="$(<$2)"
        # new buffer
        BUFFER=${result#* }
        # and new cursor position
        CURSOR=$(( ${(M)result#* } -1 ))

    } $REPLY =(<<<"$BUFFER")

}
zle -N ex-norm

bindkey -M main jk ex-norm
# bindkey -M main qq ex-norm
bindkey -M vicmd q ex-norm
