# vim: set syntax=zsh:

autoload -U add-zsh-hook
autoload -Uz vcs_info

setopt promptsubst

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
FMT_BRANCH="%{${reset_color}%}%b%u%c" # e.g. master¹²
FMT_ACTION="(%{${fg[cyan]}%}%a%{${reset_color}%}"   # e.g. (rebase-i)
FMT_PATH="%{${fg[green]}%}%R/%{${fg[yellow]}%}%S"              # e.g. ~/repo/subdir

# bunch of custom hostname colors. for most, t2cc works just fine. :)
typeset -A hostcolors
hostcolors=(
    SteelHooves $FG[245]
    )

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories   
zstyle ':vcs_info:*:prompt:*' nvcsformats   "%{${fg[green]}%}%3~" "" "»"

zstyle ':vcs_info:*' enable git svn darcs bzr hg
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '²'    # display ² if there are staged changes
zstyle ':vcs_info:*:prompt:*' max-exports 3
zstyle ':vcs_info:*:prompt:*' formats         "${FMT_PATH}" "${FMT_BRANCH} "              "%s »"
zstyle ':vcs_info:*:prompt:*' actionformats   "${FMT_PATH}" "${FMT_BRANCH}${FMT_ACTION} " "%s »"
# special hg stuff
zstyle ':vcs_info:hg:prompt:*'  formats       "${FMT_PATH}" "${FMT_BRANCH} "              "☿"
zstyle ':vcs_info:hg:prompt:*' actionformats  "${FMT_PATH}" "${FMT_BRANCH}${FMT_ACTION} " "☿"
# special git stuff
zstyle ':vcs_info:git:prompt:*' formats       "${FMT_PATH}" "${FMT_BRANCH} "              "±"
zstyle ':vcs_info:git:prompt:*' actionformats "${FMT_PATH}" "${FMT_BRANCH}${FMT_ACTION} " "±"

add-zsh-hook precmd valodim_precmd
function valodim_precmd {
  zftpdata=''
  if false && [[ "$ZFTP_HOST" != "" ]]; then
    local zftp_user=""
    if [[ "$ZFTP_USER" != "valodim" ]]; then
      zftp_user=$ZFTP_USER"%{${reset_color}%}@"
    fi
    local zftp_host_color=""
    if [[ "$ZFTP_HOST" != "$ZFTP_IP" ]]; then
      zftp_host_color=$'\e'"[$(t2cc $ZFTP_HOST)m"
    fi
    local zftp_host="%{${zftp_host_color}%}${ZFTP_HOST}%{$reset_color%}"
    local zftp_stat=":${ZFTP_CODE}"
    local zftp_cwd="%{$fg[green]%}${ZFTP_PWD}"

    zftpdata=" $FG[243]↱ %{$reset_color%}[${zftp_user}${zftp_host}$FG[243]%{$reset_color%}] ${zftp_stat} ${zftp_cwd} %{${reset_color}%}»"'
'
  fi

  vcs_info 'prompt'
}

function lprompt {
    local user=""
    if [[ "$(whoami)" != "valodim" ]]; then
      user="%(!.%{${fg_bold[red]}%}root%{$reset_color%}@.%n@)"
    fi

    # hide username if it's my regular one
    if [[ -n $hostcolors[$HOST] ]]; then
      local host_color="${hostcolors[$HOST]}"
    else
      local host_color=$FG[$(t2cc $HOST)] #$'\e'"[`$ZSH/t2cc $HOSTNAME`m"
    fi
    local host="%{${host_color}%}%M%{${reset_color}%}"

    local shlvl="%(4L.%L .)"
    local exstat="%(?.%{${fg_bold[blue]}%}::.%{${reset_color}${fg_bold[red]}%}:%?)"

    local cwd='${${vcs_info_msg_0_%%.}/$HOME/~}'
    local git1='$vcs_info_msg_1_'
    local git2='$vcs_info_msg_2_'

    local failindicator='%(?,,%{$fg[red]%}FAIL%{$reset_color%}
)'

    # disabled: \${zftpdata}
    PROMPT="${failindicator}[${user}${host}] ${shlvl}${exstat} ${cwd} ${git1}%{$reset_color%}${git2} "
}

function rprompt {
    local hist='%!'
    RPS1="${hist}"
}

lprompt
rprompt
