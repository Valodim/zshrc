# Global aliases for often used commands in the command line.
alias -g E='2>&1'
alias -g L='E | less'
alias -g N='> /dev/null'
alias -g D='E | colordiff L'
alias -g G='| grep'
alias -g S='| sort'
alias -g U='| uniq'
alias -g H='| head'
alias -g T='| tail'
alias -g C='| column -t'

alias -g ND='$(ls -d *(/om[1]))' # newest directory
alias -g NF='$(ls *(.om[1]))'    # newest file

# Make going up directories simple.
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias bell=print '\a'

alias zsmv='zmv -p sudo -o mv '

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

alias qum='quvi -e-r -e-v "URL" --exec "echo %t" --exec "mplayer %u"'
