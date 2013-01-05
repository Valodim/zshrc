# add prompts to fpath
fpath+=( $ZSH/prompt )

# initialize the prompt contrib
autoload promptinit ; promptinit

# if we are on a rxvt-unicode-256color, chances are we have powerline font enabled
if [[ $TERM == "rxvt-unicode-256color" ]]; then
    # yay, this is home! no way to detect if powerline font is available, but oh well..
    if (( $+functions[prompt_powerline_setup] )); then
        prompt powerline
    else
        prompt valodim
    fi
else
    # no 256 color terminal? fall back to my plain old prompt, then
    prompt valodim
fi
