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
        (( $ahead )) && gitstatus+=( "%F{green}+${ahead}%f" )

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        (( $behind )) && gitstatus+=( "%F{red}-${behind}%f" )

        hook_com[branch]="${hook_com[branch]}${(j:/:)gitstatus}"
    fi
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        [[ -n $stashes ]] && hook_com[misc]="%F{243}${stashes} "
    fi
}

zstyle ':vcs_info:git*+set-message:*' hooks git-stash git-st
