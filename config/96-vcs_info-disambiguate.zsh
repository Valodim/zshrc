# a lot of vcs_info related stuff happened here
autoload -U is-at-least
is-at-least 4.3.12 || return

# make sure disambiguate functions are even available, don't bother otherwise
() {
    local -a tmp;
    tmp=( $^fpath/disambiguate(N) $^fpath/disambiguate-keeplast(N) )
    (( $#tmp >= 2 ))
} || return

# this vcs_info hook changes the base and subdir variables, which are used as
# %R and %S in vcs_info styles, to non-ambiguous prefix versions, keeping the
# last path element intact.
#
# depends on disambiguate-keeplast with prefix support. plays nice with
# vcs_info-lofi.

+vi-path-disambiguate () {
    if [[ $hook_com[subdir] == '.' ]]; then
        disambiguate-keeplast $hook_com[base]
    else
        disambiguate $hook_com[base]
    fi
    hook_com[base]=$REPLY
    disambiguate-keeplast $hook_com[subdir] $hook_com[base]
    hook_com[subdir]=$REPLY

    # we don't set ret here, since this hooks merely influences the displayed
    # info, not any logic
    return 0
}

autoload -U vcs_info_hookadd disambiguate disambiguate-keeplast
vcs_info_hookadd set-message path-disambiguate
# this works with lofi-messages as well!
vcs_info_hookadd set-lofi-message path-disambiguate
