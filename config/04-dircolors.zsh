# try to load terminfo
zmodload zsh/terminfo || return 1

# only available for 256 color terminals
if (( $+terminfo[colors] )) && (( $terminfo[colors] == 256 )); then
    # load trapd00r's LS_COLORS things
    eval $( dircolors -b $ZSH/subs/LS_COLORS/LS_COLORS )
fi
