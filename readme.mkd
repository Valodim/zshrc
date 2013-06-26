My zsh configs. If you don't know what's what, you probably shouldn't use it
but get your own going. Feel free though :)

Interesting keybindings:

    editing:
        ^F edit command line in $EDITOR
        ^H run help for current $0
        ^P push line on stack
        ^O insert line from stack
        ^T undo
        ^R prepend "sudo "
        ^X^X copy $BUFFER to clipboard using xclip
        ctrl-left/right will move along argument boundaries
        repeated ... will be turned into ../.. (mikachu's rationalise-dots)

    history:
        down on empty line will clear the line but add it to history, irssi-style 
        up/down will search history on first word match
        ctrl-up/down will substring-search history

    local history:
        any directory that has a local history file (stored in
        ZSH/hist/$PWD/__hist) will use that history instead of
        the global one, unless this mechanism is disabled.

        commands:
          lhc creates a local history file for the current PWD
          lh0 disables localhist
          lh1 enables localhist
          ^G toggles localhist

    functional shortcuts:
        ^L display ls
        ^X^L clear screen (instead of ^L)
        ^Z do "fg %%" (allows neat toggling)

    in menu-complete:
        page-up will accept and complete again (go into directory)
        page-down will undo (basically, go up directory)
        menu will accept selection but stay in menu-complete

My Prompt:

  See https://github.com/Valodim/zsh-prompt-powerline

  I am at this point usually using my powerline prompt and this old one as a
  fallback if a powerline patched font is unavailable. Just keeping this info
  here for reference.


      [valodim@SteelHooves] ::1 ~/.zsh/custom master¹² 1 ±
           ^       ^        ^^^    ^     ^      ^   ^^ ^ ^
           a       b        cde    f     g      h   ij k l

    a username, only displayed if it's not "valodim" (you probably wanna change that)
    b hostname, colored using its hash
    c pwd permissions indicator, : if owned by $uid else ., yellow if only readable, red if not even readable
    d localhist indicator, : if enabled, . if disabled, colored differently if there is a localhist
    e fail indicator, displays exit status if it's != 0
    f path, nothing special about it
    g path within repository, differently colored
    h vcs branch name
    i unstaged changes indicator
    j staged changes indicator
    k number of stashed commits, if > 0
    l repository type indicator. ± for git, ☿ for hg, $name for others, » outside of repositories

  So a clean prompt [[ $PWD == $HOME ]] looks like

      [SteelHooves] :: ~ »

  beautiful, isn't it? :)

Tidbits:
 - on urxvt, the cursor will become red when in vi normal mode
 - the hostname color in the prompt is generated from a hash
 - cd completion will display the number of regular files in the current dir
 - using .. to go up directories will display the absolute path below the prompt

Caveats:
 - doesn't work well without 256 colors
 - doesn't work well for people who are not me
 - probably requires a newish zsh
