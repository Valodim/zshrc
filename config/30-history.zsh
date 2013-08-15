
# history file is inside $ZSH usually, no more stuff in $HOME than necessary
HISTFILE=${ZSH:-$HOME}/.zsh_history

# 10k items in history should suffice.
HISTSIZE=10000
SAVEHIST=10000

# ignore duplicates
setopt hist_ignore_dups
# incrementally append to history (new sessions get combined history)
setopt append_history inc_append_history
# save timestamps in history
setopt extended_history
# don't save to history if line has a space prefix
setopt hist_ignore_space

