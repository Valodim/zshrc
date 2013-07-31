# this is a hook which stops vcs_info right after the vcs detection step.
#
# this allows displaying a piece of information that the current PWD is inside
# a vcs repository and its type, without loading the heavyweight vcs data.
#
# this hook uses the :vcs_info:vcsname:usercontext:* lofiformats style, where
# only %s is replaced with the vcs name. appearance will typically be customized
# like this, if you call vcs_info with the 'bleep' usercontext:
#
# zstyle ':vcs_info:*:bleep:*'   lofiformats   "%3~ %s"
# zstyle ':vcs_info:git:bleep:*' lofiformats   "%3~ ±"
#
# this feature was hardly tested with anything besides git, and probably has
# bugs. use at your own risk.
#
+vi-lofi () {

    # locals
    local msg basedir subdir
    local -i i
    local -xA hook_com
    local -xa msgs

    # lofi mode enabled?
    if ! zstyle -t ":vcs_info:${vcs}:${usercontext}:${PWD}" lofi ; then
        # if not, just leave.
        return 0
    fi

    # get lofi styles
    zstyle -a ":vcs_info:${vcs}:${usercontext}:${rrn}" lofiformats msgs

    # if no lofi styles are set, better chicken out here
    (( $#msgs == 0 )) && return 0

    # git has the only detect mechanism that does not set the basedir. sheesh.
    if (( $+vcs_comm[gitdir] )); then
        basedir=${PWD%/${$( ${vcs_comm[cmd]} rev-parse --show-prefix )%/##}}
    elif (( $+vcs_comm[basedir] )); then
        basedir=$vcs_comm[basedir]
    else
        # no set? huh. just assume it's PWD, then...
        basedir=$PWD
    fi
    # get subdir within repo tree
    subdir="$(VCS_INFO_reposub ${basedir})"

    # process the messages as usual, but with only the vcs name as %s
    (( ${#msgs} > maxexports )) && msgs[$(( maxexports + 1 )),-1]=()
    for i in {1..${#msgs}} ; do
        if VCS_INFO_hook "set-lofi-message" $(( $i - 1 )) "${msgs[$i]}"; then
            zformat -f msg ${msgs[$i]} s:${vcs} R:${basedir} S:${subdir}
            msgs[$i]=${msg}
        else
            msgs[$i]=${hook_com[message]}
        fi
    done

    # this from msgs
    VCS_INFO_set

    # this is the value passed back up to vcs_info, which stops further processing
    ret=1
    return 1
}

# function which disables lofi for this particular directory
prompt-vcs-hifi-pwd () {
    # disable lofi mode for this directory and all subdirs
    zstyle ":vcs_info:*:*:$PWD*" lofi false

    # if this is run as a widget, ...
    if zle; then
        # manually re-run all prompt precmd functions (so vcs_info is
        # reevaluated as well), and reset prompt to update status.
        for f in ${(M)precmd_functions#prompt_*_precmd}; $f
        zle .reset-prompt
    fi
}
zle -N prompt-vcs-hifi-pwd
bindkey '^G^L' prompt-vcs-hifi-pwd

# set lofi to false for current directory, if any kind of git command is run
vcs-hifi-pwd-hook () {
    if [[ $1 == git* ]] && zstyle -t ":vcs_info:*:*:$PWD" lofi; then
        zstyle ":vcs_info:*:*:$PWD*" lofi false
    fi
    return 0
}

autoload -U add-zsh-hook
add-zsh-hook zshaddhistory vcs-hifi-pwd-hook

# all directories are lofi by default
zstyle ':vcs_info:*' lofi true
# set the hook
zstyle ':vcs_info-static_hooks:pre-get-data' hooks 'lofi'
