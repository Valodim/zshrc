if [[ -e $ZSH/subs/gistpaste ]]; then
    if [[ ! -x $ZSH/subs/gistpaste/gistpaste ]]; then
        chmod +x $ZSH/subs/gistpaste/gistpaste
    fi
    export PATH=$PATH:$ZSH/subs/gistpaste
    alias -g GP='| gistpaste'
fi
