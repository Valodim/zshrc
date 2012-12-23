autoload -Uz vcs_info

local sep1='⮀'
local sep2='⮁'

local FMT_BRANCH FMT_ACTION FMT_PATH

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
FMT_BRANCH="%b%u%c" # e.g. master¹²
FMT_ACTION="(%F{cyan}%a%f)"   # e.g. (rebase-i)
FMT_PATH="%K{black}$sep1%F{white} %R/%%F{yellow}%S%F{black}"              # e.g. ~/repo/subdir

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

zstyle ':vcs_info:*:prompt:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '²'    # display ² if there are staged changes

# non-vcs
zstyle ':vcs_info:*:prompt:*' nvcsformats   "%K{black}$sep1%F{white} %3~%F{black} "

# generic vcs
zstyle ':vcs_info:*:prompt:*' formats         "${FMT_PATH} %K{27}$sep1%F{81} %s ${FMT_BRANCH} %F{27}"
zstyle ':vcs_info:*:prompt:*' actionformats   "${FMT_PATH} %K{27}$sep1%F{81} %s ${FMT_BRANCH}${FMT_ACTION} %F{27}"

# special hg stuff
zstyle ':vcs_info:hg:prompt:*'  formats       "${FMT_PATH} %K{27}$sep1%F{81} ☿ ${FMT_BRANCH} %F{27} "
zstyle ':vcs_info:hg:prompt:*' actionformats  "${FMT_PATH} %K{27}$sep1%F{81} ☿ ${FMT_BRANCH}${FMT_ACTION} %F{27}"

# special git stuff
zstyle ':vcs_info:git:prompt:*' formats       "${FMT_PATH} %K{27}$sep1%F{123} ± ${FMT_BRANCH} %m%F{27}" # 
zstyle ':vcs_info:git:prompt:*' actionformats "${FMT_PATH} %K{27}$sep1%F{123} ± ${FMT_BRANCH}${FMT_ACTION} %m%F{27}"

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        (( $ahead )) && gitstatus+=( "%B%F{46}+${ahead}%f" )

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        (( $behind )) && gitstatus+=( "%B%F{160}-${behind}%f" )

        (( $#gitstatus )) && hook_com[misc]+="${(j:/:)gitstatus} "
    fi
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        [[ -n $stashes ]] && hook_com[misc]+="%F{81}$sep2 %B${stashes} "
    fi
}

zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash
