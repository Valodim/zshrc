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

autoload -U   edit-command-line
zle -N        edit-command-line

autoload -U   incarg
zle -N        incarg

autoload -U   insert-composed-char
zle -N        insert-composed-char

autoload -U   run-help run-help-git

autoload -U   history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# remember all ^X keybindings (like globs)
() {
    local -a ctrlx_bindings
    ctrlx_bindings=( ${(M)${(f)"$(bindkey -L)"}:#bindkey*\^X*} )

    # vi keybindings. awesome :)
    bindkey -v

    # get the ^X bindings back
    for binding in $ctrlx_bindings; do
        "${(Qz)binding[@]}"
    done
}

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
bindkey '^O' get-line
bindkey '^P' push-line
bindkey '^R' history-incremental-search-backward
bindkey '^T' undo
bindkey '^Y' insert-root-prefix
bindkey '^Z' job-foreground
bindkey . rationalise-dot

bindkey '^Xh' _complete_help
bindkey '^Xd' _complete_debug

# wrap tab completion
bindkey '^I' expand-or-complete-or-cd

bindkey -M menuselect '^N' accept-and-menu-complete
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

typeset -aH zle_keymap_select_functions
function zle-keymap-select () {
    for f in $zle_keymap_select_functions; "${(@z)f}"
}
zle -N zle-keymap-select

typeset -aH zle_line_init_functions
function zle-line-init () {
    for f in $zle_line_init_functions; "${(@z)f}"
}
zle -N zle-line-init

typeset -aH zle_line_finish_functions
function zle-line-finish () {
    for f in $zle_line_finish_functions; "${(@z)f}"
}
zle -N zle-line-finish

() {

    local -A key

    # terminfo is the preferred method
    if zmodload zsh/terminfo && (( $+terminfo[smkx] )); then

        zle_line_init_functions+=( 'echoti smkx' )
        zle_line_finish_functions+=( 'echoti rmkx' )

        key[Home]=${terminfo[khome]}
        key[End]=${terminfo[kend]}
        key[Insert]=${terminfo[kich1]}
        key[Delete]=${terminfo[kdch1]}
        key[Backspace]=${terminfo[kbs]}
        key[Up]=${terminfo[kcuu1]}
        key[Down]=${terminfo[kcud1]}
        key[Left]=${terminfo[kcub1]}
        key[Right]=${terminfo[kcuf1]}
        key[PageUp]=${terminfo[kpp]}
        key[PageDown]=${terminfo[knp]}

    elif zmodload zsh/termcap && (( $+termcap[kh] )); then

        key[Home]=${termcap[kh]}
        # wtf?
        key[End]=${termcap[@7]}
        key[Insert]=${termcap[kI]}
        key[Delete]=${termcap[kD]}
        key[Backspace]=${termcap[kb]}
        key[Up]=${termcap[ku]}
        key[Down]=${termcap[kd]}
        key[Left]=${termcap[kl]}
        key[Right]=${termcap[kr]}
        key[PageUp]=${termcap[kN]}
        key[PageDown]=${termcap[kP]}

    # otherwise, just take wild guesses!
    else

        key[Home]='^[[7~'
        key[End]='^[[8~'
        key[Insert]='^[[2~'
        key[Delete]='^[[3~'
        key[Backspace]='^?'
        key[Up]='^[OA'
        key[Down]='^[OB'
        key[Left]='^[OD'
        key[Right]='^[OC'
        key[PageUp]='^[[5~'
        key[PageDown]='^[[6~'

    fi

    # movements
    bindkey "${key[Left]}" backward-char
    bindkey "${key[Right]}" forward-char
    bindkey "${key[Home]}" beginning-of-line
    bindkey "${key[End]}" end-of-line

    # history completion up/down keys
    bindkey "${key[Up]}" history-beginning-search-backward-end
    bindkey "${key[Down]}" irssi-down

    bindkey "${key[Backspace]}" backward-delete-char
    bindkey "${key[Delete]}" delete-char

    bindkey -M menuselect "${key[PageUp]}" accept-and-infer-next-history
    bindkey -M menuselect "${key[PageDown]}" undo

}
