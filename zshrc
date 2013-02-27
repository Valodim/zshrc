# Initializes my zsh - originally based on Oh-My-Zsh

# add a function path
fpath=($ZSH/functions $fpath)
path+=($ZSH/bin)

[[ -d $ZSH/subs/zsh-completions/src ]] && fpath+=( $ZSH/subs/zsh-completions/src )

if [[ ! -a $ZSH/subs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    echo 'Missing subs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh, and probably others.'
    echo 'Did you git submodule init && git submodule update ?'
fi

# load all config files from custom/ and local/
# we do some sorting magic here: the files from both custom/ and local/ are
# ordered by their filename without regard to their path, meaning it's possible
# to specify at what point the files in local/ will be loaded. if two filenames
# are the same, the one in local/ will be loaded first.
for config_file in $ZSH/(local|custom)/*.zsh(Noe!'REPLY=${REPLY:t}'!oe!'[[ $REPLY == *local* ]] && REPLY=0 || REPLY=1'!); source $config_file
