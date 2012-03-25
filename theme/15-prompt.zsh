# vim: set syntax=zsh:

autoload -U add-zsh-hook

setopt promptsubst

# bunch of custom hostname colors. for most, t2cc works just fine. :)
typeset -A hostcolors
hostcolors=(
    fluttershy $FG[229]
    SteelHooves $FG[245]
    )


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

  if [[ -w $PWD ]]; then
      pwdstat="%B%F{blue}"
  elif [[ -r $PWD ]]; then
      pwdstat="%B%F{yellow}"
  else
      pwdstat="%B%F{red}"
  fi
  [[ -O $PWD ]] && pwdstat+=":" || pwdstat+="."

  # add info about localhist status
  # note this looks default if no localhist specific stuff happens at all
  [[ -z $localhist ]] && pwdstat+="%F{blue}" || pwdstat+="%F{cyan}"
  [[ -z $localhist_disable ]] && pwdstat+=":" || pwdstat+="."

  vcs_info 'prompt'
}

function lprompt {
    local user=""
    if [[ "$(whoami)" != "valodim" ]]; then
      user="%(!.%F{red}root%f@.%n@)"
    fi

    # hide username if it's my regular one
    if [[ -n $hostcolors[$HOST] ]]; then
      local host_color="${hostcolors[$HOST]}"
    else
      local host_color=$FG[$(t2cc $HOST)] #$'\e'"[`$ZSH/t2cc $HOSTNAME`m"
    fi
    local host="%{${host_color}%}%M%f"

    local shlvl="%(4L.%L .)"
    local exstat="%(?..%B%F{red}%?)"

    local cwd='${${vcs_info_msg_0_%%.}/$HOME/~}'
    local git1='$vcs_info_msg_1_'
    local git2='$vcs_info_msg_2_'

    local failindicator='%(?,,%{$fg[red]%}FAIL%{$reset_color%}
)'
    pwdstat="%{${fg_bold[blue]}%}:"

    # disabled: \${zftpdata}
    PROMPT="${failindicator}[${user}${host}] ${shlvl}\${pwdstat}${exstat} ${cwd} ${git1}%f%b${git2} "
}

function rprompt {
    local hist='%!'
    RPS1="${hist}"
}

lprompt
rprompt
