autoload -Uz vcs_info

local FMT_BRANCH FMT_ACTION FMT_PATH

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
FMT_BRANCH="%f%%b%b%u%c" # e.g. master¹²
FMT_ACTION="(%F{cyan}%a%f"   # e.g. (rebase-i)
FMT_PATH="%F{green}%R/%%F{yellow}%S"              # e.g. ~/repo/subdir

zstyle ':vcs_info:*' enable git svn darcs bzr hg

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

zstyle ':vcs_info:*:prompt:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '²'    # display ² if there are staged changes

# non-vcs
zstyle ':vcs_info:*:prompt:*' nvcsformats   "%F{green}%3~%f »"

# generic vcs
zstyle ':vcs_info:*:prompt:*' formats         "${FMT_PATH} ${FMT_BRANCH} %s »"
zstyle ':vcs_info:*:prompt:*' actionformats   "${FMT_PATH} ${FMT_BRANCH}${FMT_ACTION} %s »"

# special hg stuff
zstyle ':vcs_info:hg:prompt:*'  formats       "${FMT_PATH} ${FMT_BRANCH} ☿"
zstyle ':vcs_info:hg:prompt:*' actionformats  "${FMT_PATH} ${FMT_BRANCH}${FMT_ACTION} ☿"

# special git stuff
zstyle ':vcs_info:git:prompt:*' formats       "${FMT_PATH} ${FMT_BRANCH} %m%f±"
zstyle ':vcs_info:git:prompt:*' actionformats "${FMT_PATH} ${FMT_BRANCH}${FMT_ACTION} %m%f±"

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        [[ -n $stashes ]] && hook_com[misc]="%F{243}${stashes} "
    fi
}

zstyle ':vcs_info:git*+set-message:*' hooks git-stash
