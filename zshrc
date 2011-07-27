# Initializes my zsh - originally based on Oh-My-Zsh

# add a function path
fpath=($ZSH/functions $ZSH/subs/zsh-completions $fpath)

# Load all libraries first
for config_file in $ZSH/lib/*.zsh(N); source $config_file

# Load all of your custom configurations from custom/
for config_file in $ZSH/custom/*.zsh(N); source $config_file

# Same for locals
for config_file in $ZSH/local/*.zsh(N); source $config_file

# Same for theme files
for config_file in $ZSH/theme/*.zsh(N); source $config_file
