# Colorize stderr in red. Very useful when looking for errors. Thanks to
# http://gentoo-wiki.com/wiki/Zsh for the basic script and Mikachu in #zsh on
# Freenode (2010-03-07 04:03) for some improvements (-r, printf). It's not yet
# perfect and doesn't work with su and git for example, but it can handle most
# interactive output quite well (even with no trailing new line) and in cases
# it doesn't work, the E alias can be used as workaround.

# exec 2>>(while read -r -k -u 0 line; do
    # printf '\e[91m%s\e[0m' "$line";
    # print -n $'\0';
# done &)
