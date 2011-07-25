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

# Make going up directories simple.
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias bell=print '\a'
