# zmv for moving files properly
autoload -U zmv

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
  if [[ $#jobstates > 0 ]]; then
      fg
      zle .reset-prompt
  fi
}
zle -N job-foreground

inline-ls-lastarg() {
    local lastarg=${${(z)BUFFER}[-1]}
    [[ -n $lastarg && -e $lastarg ]] || { zle -M "Last arg not a valid filename!" && return 0 }
    zle -M -- "$(command ls -l -d -h -- $lastarg)"
}
zle -N inline-ls-lastarg

inline-ls() {
    zle push-line
    BUFFER=" ls"
    zle accept-line
}
zle -N inline-ls

edit-arg() {
    local -a largs
    largs=( ${(z)LBUFFER} )
    zle push-line
    BUFFER=" ${EDITOR:-vim} ${largs[-1]}"
    zle accept-line
}
zle -N edit-arg

function accept-line-rdate() {
    local old=$RPROMPT
    RPROMPT=$(date +%T 2>/dev/null)
    zle reset-prompt
    RPROMPT=$old
    zle accept-line
};
zle -N accept-line-rdate

function vi-goto-word() {
    # get buffer into a word-split array
    local -a a
    a=( ${(z)BUFFER} )

    # did we get a numeric argument? otherwise go to the first argument (right after the command)
    local num=${NUMERIC:-1}
    # set cursor to length of the first two arrays
    CURSOR=$(( ${(c)#${a[1,$num]}} +1 ))
}
zle -N vi-goto-word

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

function copy-to-clipboard() {
    (( $+commands[xclip] )) || return
    echo -n $BUFFER | xclip -i
}
zle -N copy-to-clipboard

# expand-or-complete, but sets buffer to "cd" if it's empty
function expand-or-complete-or-cd() {
    if [[ $#BUFFER == 0 ]]; then
        BUFFER="cd "
        CURSOR=3
        # don't want that after all
        # zle menu-expand-or-complete
        zle menu-expand-or-complete
    else
        zle expand-or-complete
    fi
}
zle -N expand-or-complete-or-cd

# automatically escape parsed urls
autoload -U url-quote-magic
if [[ $+functions[_zsh_highlight] == 1 ]]; then
    function _url-quote-magic() { url-quote-magic; _zsh_highlight }
    zle -N self-insert _url-quote-magic
else
    zle -N self-insert url-quote-magic
fi

# just type '...' to get '../..'
function rationalise-dot() {
  local MATCH
  if [[ $LBUFFER =~ '(^|/| |    |'$'\n''|\||;|&)\.\.$' ]]; then
    LBUFFER+=/
    zle self-insert
    zle self-insert
  else
    zle self-insert
  fi
}
zle -N rationalise-dot

autoload -U   edit-command-line
zle -N        edit-command-line

autoload -U   incarg
zle -N        incarg

autoload -U   insert-composed-char
zle -N        insert-composed-char

autoload -U   run-help run-help-git

# vi keybindings. awesome :)
bindkey -v
# bindkey '^A' incarg
bindkey '^A' beginning-of-line
bindkey '^B' accept-and-infer-next-history
bindkey '^E' end-of-line
bindkey '^F' edit-command-line
bindkey '^G' localhist-toggle
bindkey '^H' run-help
bindkey '^K' insert-composed-char
bindkey '^X^L' clear-screen
bindkey '^X^V' edit-arg
bindkey '^X^N' inline-ls-lastarg
bindkey '^X^X' copy-to-clipboard
bindkey '^L' inline-ls
bindkey '^M' accept-line-rdate
bindkey '^N' accept-and-menu-complete
bindkey '^O' get-line
bindkey '^P' push-line
bindkey '^R' insert-root-prefix
bindkey '^T' undo
bindkey '^Z' job-foreground
bindkey . rationalise-dot

bindkey '^Xh' _complete_help
bindkey '^Xd' _complete_debug

# wrap tab completion
bindkey '^I' expand-or-complete-or-cd

bindkey -M vicmd g vi-goto-word

autoload -U select-word-style backward-word-match forward-word-match
select-word-style shell

zle -N backward-word-match
zle -N forward-word-match

# ctrl-left & ctrl-right
bindkey '^[Od' backward-word-match
bindkey '^[OD' backward-word-match
bindkey '^[Oc' forward-word-match
bindkey '^[OC' forward-word-match

# ctrl-up and ctrl-down for substring search
bindkey '^[Oa' history-substring-search-up
bindkey '^[Ob' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

bindkey -M viins jj vi-cmd-mode-samepos

if [[ ! -a ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} && ! -a $ZSH/zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]]; then
    echo "Warning: Missing keymap, run autoload zkbd && zkbd. Using defaults.."
    source $ZSH/zkbd/fallback
else
    if [[ -a ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]]; then
        source ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
    else
        source $ZSH/zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
    fi
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
