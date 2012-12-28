local sep1='⮀'
local sep2='⮁'

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
  # the variable we add our bits to
  prompt_stats=

  # add info about localhist status, if there is any
  if [[ -n $localhist ]]; then
      # disabled = red, enabled = blue, enabled for parent dir = yellow
      if [[ -n $localhist_disable ]]; then
          prompt_stats+="%F{red}⭠ "
      elif [[ -n $localhist_specific ]]; then
          prompt_stats+="%F{12}⭠ "
      else
          prompt_stats+="%F{yellow}⭠ "
      fi
  fi

  # show stats for this dir
  if [[ ! -O $PWD ]]; then
      if [[ -w $PWD ]]; then
          prompt_stats+="%F{blue}⭤ "
      elif [[ -x $PWD ]]; then
          prompt_stats+="%F{yellow}⭤ "
      elif [[ -r $PWD ]]; then
          prompt_stats+="%F{red}⭤ "
      fi
  fi
  if [[ ! -w $PWD && ! -r $PWD ]]; then
      prompt_stats+="%F{red}⭤ "
  fi

  # end the hostname background
  prompt_stats+="%F{238}"

  if [[ -z $prompt_simple ]]; then
      vcs_info 'prompt'
  else
      zstyle -g vcs_info_msg_0_ ':vcs_info:*:prompt:*' nvcsformats 
      if git rev-parse --is-inside-work-tree &> /dev/null; then
          # strip last space and append a blue segment to indicate we're in a vcs dir
          vcs_info_msg_0_="${vcs_info_msg_0_[1,-1]}%K{blue}$sep1%F{blue}"
      fi
  fi
}

function lprompt {
    local user=""
    if [[ "$(whoami)" != "valodim" ]]; then
        user="%(!.%F{red}.%F{247})%n $sep2 "
    fi

    # hide username if it's my regular one
    if [[ -n $hostcolors[$HOST] ]]; then
      local host_color=$(( ${hostcolors[$HOST]} % $(echotc Co) ))
    else
      local host_color=$(t2cc $HOST) #$'\e'"[`$ZSH/t2cc $HOSTNAME`m"
    fi

    local userhost="${user}%F{$host_color}${HOST}%F{238}"

    # old version, inner-prompt segment
    # local shlvl="%(2L.%K{104}$sep1%F{white} %L %F{104}.)"
    # new version, repeated > before host
    local shlvl="%K{238}%F{$host_color}$sep1${(l:$SHLVL-1::⮁:):-} "
    local exstat="%(?..%K{red}$sep1%F{white} %B%? %b%F{red})"
    local jobstat="%(1j.%K{green}$sep1%F{white} %B%j %b%F{green}.)"
    local gitinfo='${${vcs_info_msg_0_%%.}/$HOME/~}'

    # special bits from precmd
    prompt_stats="%F{black}"

    PROMPT="${shlvl}${userhost} \$prompt_stats${exstat}${jobstat}${gitinfo}%k$sep1%b%f "
}

lprompt

