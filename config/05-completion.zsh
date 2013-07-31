unsetopt menu_complete
setopt auto_menu complete_in_word always_to_end

zmodload -i zsh/complist

autoload -U compinit
compinit -i

# completion stuff
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path $ZSH/cache/

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# This is needed to workaround a bug in _setup:12, causing almost 2 seconds delay for bigger LS_COLORS
zstyle ':completion:*:*:-command-:*' list-colors ''

# Completion Styles

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate:*' max-errors 3
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' auto-description '%d'

# match uppercase from lowercase, and left-side substrings
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' '+l:|=*'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
# on processes completion complete all user processes
# zstyle ':completion:*:processes' command 'ps -au$USER'

# x11 colors
zstyle ":completion:*:colors" path '/etc/X11/rgb.txt'

## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#zstyle ':completion:*:processes' command 'ps ax -o pid,s,nice,stime,args | sed "/ps/d"'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd\
        avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail\
        firebird gnats haldaemon hplip irc klog list man cupsys postfix\
        proxy syslog www-data mldonkey sys snort

zstyle ':completion:*:*:cs:*' file-patterns \
  '*(-/):directories'
zstyle ':completion:*:*:evince(syn|):*' file-patterns \
  '*.(pdf|PDF):pdf\ files *(-/):directories'

zstyle ':completion:*:*:vi(m|):*:*files' ignored-patterns \
  '*?.(aux|dvi|ps|pdf|bbl|toc|lot|lof|o|cm|class?)'

zle -C complete-history complete-word _generic
zstyle ':completion:complete-history:*' completer _history

zstyle ':complete-recent-args' use-histbang yes

() {

    local -a coreutils
    coreutils=(
        # /bin
        cat chgrp chmod chown cp date dd df dir ln ls mkdir mknod mv readlink
        rm rmdir vdir sleep stty sync touch uname mktemp
        # /usr/bin
        install hostid nice who users pinky stdbuf base64 basename chcon cksum
        comm csplit cut dircolors dirname du env expand factor fmt fold groups
        head id join link logname md5sum mkfifo nl nproc nohup od paste pathchk
        pr printenv ptx runcon seq sha1sum sha224sum sha256sum sha384sum
        sha512sum shred shuf sort split stat sum tac tail tee timeout tr
        truncate tsort tty unexpand uniq unlink wc whoami yes arch touch
    )

    for i in $coreutils; do
        # all which don't already have one
        # at time of this writing, those are:
        # /bin
        #   chgrp chmod chown cp date dd df ln ls mkdir rm rmdir stty sync
        #   touch uname
        # /usr/bin
        #   nice comm cut du env groups id join logname md5sum nohup printenv
        #   sort stat unexpand uniq whoami
        (( $+_comps[$i] )) || compdef _gnu_generic $i 
    done

}
