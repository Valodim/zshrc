#! /bin/zsh
# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
# Copied from http://github.com/sykora/etc/blob/master/zsh/functions/spectrum/

typeset -Ag FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

for color in {0..255}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

function t2cc {
  sum=$(echo "$1" | sha1sum | tr -c -d 123456789 | tail -c 15 -)
  if [[ $TERM == "rxvt-unicode" || $TERM == "rxvt-unicode-256color" || $(echotc Co) == "256" ]]
    then sum=$(( $sum % 256 ))
    else sum=$(( $sum % 88 ))
    fi
  echo $sum
}

function spectrum {
  for color in {0..255}; do echo "${FG[$color][3,-3]} $color" ; done
}

