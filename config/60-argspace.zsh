autoload -U add-zsh-hook
autoload -U is-at-least

argspace_chpwd() {
    jobs -Z "zsh $PWD"
}

# zsh until 5.0 has a bad bug where jobs -Z completely screws up
# the env, we'd better avoid it for that version.
# see: http://www.zsh.org/mla/users/2012/msg00717.html

is-at-least 5.0.1 && add-zsh-hook chpwd argspace_chpwd
