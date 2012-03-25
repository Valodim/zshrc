## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups hist_expire_dups_first
setopt hist_verify inc_append_history extended_history hist_ignore_space append_history

unsetopt share_history
