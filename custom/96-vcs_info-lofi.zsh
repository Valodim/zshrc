# this is a hook which stops vcs_info right after detection step.
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
+vi-lofi () {

    # locals
    local msg
    local -i i
    local -xA hook_com
    local -xa msgs

    zstyle -a ":vcs_info:${vcs}:${usercontext}:${rrn}" lofiformats msgs

    # if no lofi styles are set, better chicken out here
    (( $#msgs == 0 )) && return 0

    # process the messages as usual, but with only the vcs name as %s
    (( ${#msgs} > maxexports )) && msgs[$(( maxexports + 1 )),-1]=()
    for i in {1..${#msgs}} ; do
        if VCS_INFO_hook "set-lofi-message" $(( $i - 1 )) "${msgs[$i]}"; then
            zformat -f msg ${msgs[$i]} s:${vcs}
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

# set the hook
zstyle ':vcs_info-static_hooks:pre-get-data' hooks 'lofi'
