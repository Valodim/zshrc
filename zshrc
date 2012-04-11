# Initializes my zsh - originally based on Oh-My-Zsh

# add a function path
fpath=($ZSH/functions $ZSH/subs/zsh-completions $fpath)
path+=($ZSH/bin)

if [[ ! -a $ZSH/subs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    echo 'Missing subs/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh, and probably others.'
    echo 'Did you git submodule init && git submodule update ?'
fi

# Load all libraries first
for config_file in $ZSH/lib/*.zsh(N); source $config_file

# Load all of your custom configurations from custom/
for config_file in $ZSH/custom/*.zsh(N); source $config_file

# Same for locals
for config_file in $ZSH/local/*.zsh(N); source $config_file

# Same for theme files
for config_file in $ZSH/theme/*.zsh(N); source $config_file
