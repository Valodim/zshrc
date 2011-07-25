#!/bin/zsh

# awesome mode :)
alias -g ND='$(ls -d *(/om[1]))' # newest directory
alias -g NF='$(ls *(.om[1]))'    # newest file

alias -g CPP='*.cpp *.h'    # newest file
alias -g CPPS='**/*.cpp **/*.h'    # newest file

# multimove
alias mmv='noglob zmv -W'

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Basic directory operations
alias ...='cd ../..'
alias -- -='cd -'

# Super user
alias _='sudo'

#alias g='grep -in'

# Show history
alias history='fc -l 1'

# some more ls aliases
alias ls='ls --color=auto -h'
alias ll='ls -l -h'
alias la='ls -A'
alias l='ls -CF'

# rsync
alias rscp="nocorrect rsync -aP --no-whole-file --inplace"
alias rsmv="nocorrect rscp --remove-source-files"

alias bye='logout'
