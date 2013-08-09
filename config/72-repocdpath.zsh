# a lot of vcs_info related stuff happened here
autoload -U is-at-least
is-at-least 4.3.12 || return

# this hook adds the base path of a repository to the cdpath, for as long as
# the pwd stays inside the repository.
#
# plays nice with vcs_info-lofi.

typeset -H repocdpath_dir

+vi-repocdpath () {

    # cases: no known base dir
    if [[ -z $hook_com[base] ]]; then

        # any old repocdpath_dir? this should be handled by chpwd hook as well, just making sure.
        if [[ -n $repocdpath_dir ]]; then
            cdpath=( ${cdpath:#$repocdpath_dir} )
            repocdpath_dir=""
        fi

        # nothing to do here
        return
    fi

    # at this point, we know there is a base dir. if it's the same, don't bother.
    [[ $hook_com[base] == $repocdpath_dir ]] && return

    # otherwise, is it a different one? unset the old one, then.
    if [[ $hook_com[base] != $repocdpath_dir ]]; then
        cdpath=( ${cdpath:#$repocdpath_dir} )
    fi

    # and set the new one.
    cdpath+=( $hook_com[base] )
    repocdpath_dir=$hook_com[base]

    # just sniffing dat base path, don't mind me. :)
    return 0

}

# remove repo from cdpath when we leave
repocdpath_chpwd () {
    # new pwd no longer subdir of repocdpath_dir?
    if ! [[ $PWD == $repocdpath_dir* ]]; then
        # remove from cdpath, then.
        cdpath=( ${cdpath:#$repocdpath_dir} )
        repocdpath_dir=""
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd repocdpath_chpwd

# add to hooks
autoload -U vcs_info_hookadd
vcs_info_hookadd set-message repocdpath
vcs_info_hookadd set-lofi-message repocdpath
