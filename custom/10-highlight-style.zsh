
# setup stuff
ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$ZSH/subs/zsh-syntax-highlighting/highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

typeset -A ZSH_HIGHLIGHT_STYLES
: ${ZSH_HIGHLIGHT_STYLES[default]:=none}
: ${ZSH_HIGHLIGHT_STYLES[unknown-token]:=fg=red,bold}
: ${ZSH_HIGHLIGHT_STYLES[reserved-word]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[alias]:=fg=226}
: ${ZSH_HIGHLIGHT_STYLES[builtin]:=fg=141}
: ${ZSH_HIGHLIGHT_STYLES[function]:=fg=214}
: ${ZSH_HIGHLIGHT_STYLES[command]:=fg=118}
: ${ZSH_HIGHLIGHT_STYLES[hashed-command]:=fg=119}
: ${ZSH_HIGHLIGHT_STYLES[path]:=underline}
: ${ZSH_HIGHLIGHT_STYLES[globbing]:=fg=105}
: ${ZSH_HIGHLIGHT_STYLES[history-expansion]:=fg=63}
: ${ZSH_HIGHLIGHT_STYLES[single-hyphen-option]:=239}
: ${ZSH_HIGHLIGHT_STYLES[double-hyphen-option]:=241}
: ${ZSH_HIGHLIGHT_STYLES[back-quoted-argument]:=none}
: ${ZSH_HIGHLIGHT_STYLES[single-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[double-quoted-argument]:=fg=yellow}
: ${ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]:=fg=cyan}
: ${ZSH_HIGHLIGHT_STYLES[assign]:=none}
