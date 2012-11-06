autoload -U add-zsh-hook

# rehash on SIGUSR1
TRAPUSR1() { rehash };

# anything newly intalled from last command?
precmd_install() { [[ $history[$[ HISTCMD -1 ]] == *(apt-get|aptitude|pip)* ]] && killall -USR1 zsh }

# do this on precmd
add-zsh-hook precmd precmd_install
