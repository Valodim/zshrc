if [[ -e $ZSH/subs/autojump ]]; then
    source $ZSH/subs/autojump/autojump.zsh
    export PATH=$PATH:$ZSH/subs/autojump
    alias js="autojump --stat"
fi
