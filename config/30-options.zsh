
## directory changing

# implicit cd if directory is used as command
setopt autocd

# make cd behave like pushd, and enable some convenience functions for pushd
setopt autopushd pushdignoredups
setopt pushdtohome pushdminus pushdsilent 


## completion options

# list choices if completion is ambiguous
setopt autolist

# if a word matches exactly, accept it even if ambiguous
setopt recexact

# completions don't have to be equally spaced
setopt listpacked

# show file types in completion ( / for dirs, = for pipes, @ for symlinks, etc..)
setopt listtypes


## interactive type features, mostly zle stuff

# use '' inside ' quotes to write a single ' character (only interactively!)
setopt rcquotes

# allow # for comments interactively (helpful for history annotation)
setopt interactivecomments

# require >! to overwrite a file
setopt noclobber


## globbing

# enable ^, ~, # and glob flags in glob expressions (oh yes)
setopt extendedglob

# sort globs numerically (8 9 10 11, not 10 11 8 9)
setopt numericglobsort

# ~ substitution and tab completion after a = (for --x=filename args)
setopt magicequalsubst


## job control

# for single commands, resume matching jobs instead
setopt autoresume

# list jobs in long format
setopt longlistjobs

# notify us about job status changes immediately
setopt notify


## negatives

# don't run background jobs in lower prio by default
unsetopt bgnice
# directories don't need to end in a slash
unsetopt autoparamslash
# never beep on error!
unsetopt beep

