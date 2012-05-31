
# bunch of settings
setopt   notify pushdtohome cdablevars autolist
setopt   autocd recexact longlistjobs noclobber
setopt   autoresume pushdsilent pushd_ignore_dups
setopt   autopushd pushdminus extendedglob rcquotes
setopt   interactivecomments
unsetopt bgnice autoparamslash beep

setopt listpacked listtypes

autoload colors; colors

zle_highlight=(region:underline
               special:bold
              )

setopt numericglobsort
