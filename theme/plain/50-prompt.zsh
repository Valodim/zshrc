# vim: set syntax=zsh:

autoload -U add-zsh-hook
autoload -U t2cc

setopt promptsubst

# bunch of custom hostname colors. for most, t2cc works just fine. :)
typeset -A hostcolors
hostcolors=(
    fluttershy 229
    SteelHooves 245
    )


add-zsh-hook precmd valodim_precmd
function valodim_precmd {
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

  (( $+ld_preload[(r)*stderred*] )) || pwdstat+="%F{red}:"

  vcs_info 'prompt'
}

function lprompt {
    local user=""
    if [[ "$(whoami)" != "valodim" ]]; then
      user="%(!.%F{red}root%f@.%n@)"
    fi

    # hide username if it's my regular one
    if [[ -n $hostcolors[$HOST] ]]; then
      local host_color=$FG[$(( ${hostcolors[$HOST]} % $(echotc Co) ))]
    else
      local host_color=$FG[$(t2cc $HOST)] #$'\e'"[`$ZSH/t2cc $HOSTNAME`m"
    fi
    local host="%{${host_color}%}%M%f%b%u%k"

    local shlvl="%(4L.%L .)"
    local exstat="%(?..%B%F{red}%?)"

    local gitinfo='${${vcs_info_msg_0_%%.}/$HOME/~}'

    pwdstat="%B%F{blue}::"

    PROMPT="[${user}${host}] ${shlvl}\${pwdstat}${exstat} $gitinfo %b%f"
}

function rprompt {
    local hist='%!'
    RPS1="${hist}"
}

lprompt
rprompt
