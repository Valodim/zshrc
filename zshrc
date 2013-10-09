# Initialization

# add a function path
fpath=($ZSH/functions $ZSH/subs/**/functions(N) $fpath)
path+=($ZSH/bin)

[[ -d $ZSH/subs/zsh-completions/src ]] && fpath+=( $ZSH/subs/zsh-completions/src )

if [[ ! -a $ZSH/subs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    echo 'Missing subs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh, and probably others.'
    echo 'Did you git submodule init && git submodule update ?'
fi

# load all config files from config/, module/ and local/ we do some sorting
# magic here: the files from all three directories are ordered by their
# filename without regard to their path, meaning it's possible to specify at
# what point the files in local/ will be loaded. if two filenames are the same,
# the one in local/ will be loaded first. the ^-@ ignores dead symlinks, which
# are probably the result of missing submodles.
for config_file in $ZSH/(local|config|modules|lib)/*.zsh(Noe!'REPLY=${REPLY:t}'!oe!'[[ $REPLY == *local* ]] && REPLY=0 || REPLY=1'!^-@); source $config_file
