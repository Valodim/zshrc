# Global aliases for often used commands in the command line.
alias -g E='2>&1'
alias -g L='E | less'
alias -g N='/dev/null'
alias -g D='E | colordiff L'
alias -g G='| grep'
alias -g S='| sort'
alias -g U='| uniq'
alias -g H='| head'
alias -g T='| tail'
alias -g C='| column -t'

alias bell=print '\a'

alias zsmv='zmv -p sudo -o mv '

# Show history
alias history='fc -l 1'

# some more ls aliases
alias ls='ls --color=auto -h'
alias ll='ls -l -h'
alias la='ls -A'
alias l='ls -CF'

# git
alias g='git '
# who needs ghostscript, anyways...
alias gs='git status '

alias ag='ack-grep '

# rsync
alias rscp="nocorrect rsync -aP --no-whole-file --inplace "
alias rsmv="nocorrect rscp --remove-source-files "
alias rsucp="nocorrect sudo rsync -aP --no-whole-file --inplace "
alias rsumv="nocorrect rsucp --remove-source-files "

alias qum='quvi -e-r -e-v "URL" --exec "echo %t" --exec "mplayer %u"'

alias t1='tmux attach -t 0'
alias t2='tmux attach -t 1'
alias t3='tmux attach -t 2'

# note: for multiple -n arguments, the last one will take precedence. so we can
# do this without losing functionality.
alias tail='tail -n 10 '
