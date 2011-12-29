
# bunch of settings
setopt   notify pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs noclobber
setopt   autoresume histignoredups pushdsilent pushd_ignore_dups
setopt   autopushd pushdminus extendedglob rcquotes
setopt   interactivecomments
unsetopt bgnice autoparamslash beep sharehistory hist_verify

setopt listpacked listtypes

autoload colors; colors

zle_highlight=(region:underline
               special:bold
              )
