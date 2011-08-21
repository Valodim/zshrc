# zmv for moving files properly
autoload -U zmv

# edit command line with vi
insert-root-prefix() {
  BUFFER="sudo $BUFFER"
  CURSOR=$(($CURSOR + 5))
}
zle -N insert-root-prefix

vi-cmd-mode-samepos() {
  zle vi-cmd-mode
  zle forward-char
}
zle -N vi-cmd-mode-samepos

job-foreground() {
  if [[ $(jobs | wc -l) > 0 ]]; then
      fg
  fi
}
zle -N job-foreground

inline-ls() {
    zle push-line
    BUFFER=" ls"
    zle accept-line
}
zle -N inline-ls

function irssi-down() {
    if [[ -n "$BUFFER" && ${(%):-'%!'} == $HISTNO ]]; then
        print -s "$BUFFER"
        zle end-of-history
        BUFFER=''
    else
        zle down-line-or-search
    fi
}
zle -N irssi-down

# automatically escape parsed urls
autoload -U url-quote-magic
if [[ $+functions[_zsh_highlight] == 1 ]]; then
    function _url-quote-magic() { url-quote-magic; _zsh_highlight }
    zle -N self-insert _url-quote-magic
else
    zle -N self-insert url-quote-magic
fi

autoload -U   edit-command-line
zle -N        edit-command-line

autoload -U   incarg
zle -N        incarg

autoload -U   insert-composed-char
zle -N        insert-composed-char

# vi keybindings. awesome :)
bindkey -v
# bindkey '^A' incarg
bindkey '^A' beginning-of-line
bindkey '^B' accept-and-infer-next-history
bindkey '^E' end-of-line
bindkey '^F' edit-command-line
bindkey '^H' run-help
bindkey '^K' insert-composed-char
bindkey '^X^L' clear-screen
bindkey '^L' inline-ls
bindkey '^N' accept-and-menu-complete
bindkey '^O' get-line
bindkey '^P' push-line
bindkey '^R' insert-root-prefix
bindkey '^T' undo
bindkey '^Z' job-foreground

# ctrl-left & ctrl-right
bindkey '^[Od' backward-word
bindkey '^[OD' backward-word
bindkey '^[Oc' forward-word
bindkey '^[OC' forward-word

# ctrl-up and ctrl-down for substring search
bindkey '^[Oa' history-substring-search-up
bindkey '^[Ob' history-substring-search-down

bindkey -M viins jj vi-cmd-mode-samepos

if [[ ! -a ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} && ! -a $ZSH/zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]]; then
    echo "Warning: Missing keymap, run autoload zkbd && zkbd!"
else
    if [[ -a ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]]; then
        source ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
    else
        source $ZSH/zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
    fi

    # move left and right
    bindkey "${key[Left]}" backward-char
    bindkey "${key[Right]}" forward-char

    # history completion up/down keys
    bindkey "${key[Up]}" up-line-or-search
    bindkey "${key[Down]}" irssi-down

    bindkey "${key[Backspace]}" backward-delete-char
    bindkey "${key[Delete]}" delete-char

    bindkey -M menuselect "${key[Menu]}" accept-and-menu-complete
    bindkey -M menuselect "${key[PageUp]}" accept-and-infer-next-history
    bindkey -M menuselect "${key[PageDown]}" undo

    bindkey -M menuselect h backward-char
    bindkey -M menuselect j down-history
    bindkey -M menuselect jj down-history
    bindkey -M menuselect k up-history
    bindkey -M menuselect l forward-char

    bindkey -M menuselect o accept-and-menu-complete
    bindkey -M menuselect i accept-and-infer-next-history
    bindkey -M menuselect u undo

fi
