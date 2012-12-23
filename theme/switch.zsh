
# TODO: use promptinit for prompt theme management

# select a theme, if not already selected
if [[ -z $ZSH_THEME ]]; then
    [[ $TERM == "rxvt-unicode-256color" ]] && ZSH_THEME=powerline || ZSH_THEME=plain
else
    if [[ ! -d $ZSH/theme/$ZSH_THEME ]]; then
        echo "Invalid ZSH_THEME specified, falling back to plain."
        ZSH_THEME=plain
    fi
fi

# load theme files
for i in $ZSH/theme/$ZSH_THEME/*.zsh; do
    source $i
done

