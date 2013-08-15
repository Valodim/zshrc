
## contrib widgets

autoload -U   edit-command-line
zle -N        edit-command-line

autoload -U   incarg
zle -N        incarg

autoload -U   run-help run-help-git

autoload -U   history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

autoload -U select-word-style backward-kill-word-match backward-word-match forward-word-match
select-word-style shell

zle -N backward-kill-word-match
zle -N backward-word-match
zle -N forward-word-match

# for backward-kill, all but / are word chars (ie, delete word up to last directory)
zstyle ':zle:backward-kill-word*' word-style standard
zstyle ':zle:*kill*' word-chars '*?_-.[]~=&;!#$%^(){}<>'


## custom widgets

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
      zle .push-line
      BUFFER=" fg"
      zle .accept-line
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

# this function works like history-beginning-search-forward-end, except at the
# bottom end of history, if the buffer is non-empty, it is put into history.
# this way, commands can be "stashed away" into history without being run, just
# like in irssi.
function irssi-down() {
    if [[ -n "$BUFFER" && ${(%):-'%!'} == $HISTNO ]]; then
        print -s "$BUFFER"
        zle end-of-history
        BUFFER=''
    else
        # compatibility with history-beginning-search-forward-end
        integer cursor=$CURSOR mark=$MARK
        if [[ $LASTWIDGET == history-beginning-search-*-end || $LASTWIDGET == irssi-down ]]
        then
            CURSOR=$MARK
        else
            MARK=$CURSOR
        fi
        if zle .history-beginning-search-forward; then
            zle .end-of-line
        else
            CURSOR=$cursor
            MARK=$mark
            return 1
        fi
    fi
}
zle -N irssi-down

function copy-to-clipboard() {
    (( $+commands[xclip] )) || return
    echo -E -n - "$BUFFER" | xclip -i
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
  local MATCH dir
  if [[ $LBUFFER =~ '(^|/| |    |'$'\n''|\||;|&)\.\.$' ]]; then
    LBUFFER+=/
    zle self-insert
    zle self-insert
    dir=${${(z)LBUFFER}[-1]}
    [[ -e $dir ]] && zle -M $dir(:a)
  elif [[ $LBUFFER[-1] == '.' ]]; then
    zle self-insert
    dir=${${(z)LBUFFER}[-1]}
    [[ -e $dir ]] && zle -M $dir(:a)
  else
    zle self-insert
  fi
}
zle -N rationalise-dot

