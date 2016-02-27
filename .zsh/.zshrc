#
# zshrc {{{
# Executes commands at the start of an interactive session.
#

if [[ -n $ZSH_DEBUG ]]; then; echo 'Loading $HOME/.zshrc'; fi

# }}}
####################################################################################################
#
# Terminal settings
#

stty -ixon
stty -iutf8
stty speed 115200 > /dev/null

# }}}
####################################################################################################
#
# compinit & bashcompinit
#

autoload -Uz compinit compdef; compinit -i
autoload -U +X bashcompinit && bashcompinit

# }}}
####################################################################################################
#
# Zsh Global {{{
#

# Set the Zsh modules to load (man zshmodules)
# Load Zsh modules
zstyle ':zrc:load' zmodule 'attr' 'stat' 'pcre' 'net/socket' 'db/gdbm' 'libzpython'
zstyle -a ':zrc:load' zmodule 'zmodules'
for zmodule ("$zmodules[@]") zmodload "zsh/${(z)zmodule}"
unset zmodule{s,}

# Set the Zsh functions to load (man zshcontrib)
# Autoload Zsh functions
zstyle ':zrc:load' zfunction 'zargs' 'zmv' 'mcd'
zstyle -a ':zrc:load' zfunction 'zfunctions'
for zfunction ("$zfunctions[@]") autoload -Uz "$zfunction"
unset zfunction{s,}

# Import Apple default /etc/zshrc
# Correctly display UTF-8 with combining characters.
if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
    setopt combiningchars
fi

REPORTTIME=20              # Output zsh command response
unsetopt CORRECT           # Disable zsh correct
setopt IGNOREEOF           # Disable '^D' logout keybind
setopt MAGIC_EQUAL_SUBST   # Enable show prefix = in completions
setopt MARK_DIRS           # Auto completion on folder end slash
setopt LIST_TYPES          # Marking file info on completion list
setopt ALWAYS_LAST_PROMPT  # Keep cursor on completion
setopt GLOBDOTS            # Show dotfiles on completion

# directory
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt CLOBBER            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.
# }}}
####################################################################################################
#
# Zsh history {{{
#

HISTFILE=~/.zhistory
HISTSIZE=500000000000            # Memory History size
SAVEHIST=1000000000000           # Save History size
setopt BANG_HIST                 # Treat the '!' character specially during expansion
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt HIST_EXPAND               # Expand automatically history to completion
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt HIST_VERIFY               # Do not execute immediately upon history expansion
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY             # Share history between all sessions

# Set highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root)
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=green
ZSH_HIGHLIGHT_STYLES[alias]=bg=blue
ZSH_HIGHLIGHT_STYLES[builtin]=bg=blue
ZSH_HIGHLIGHT_STYLES[function]=bg=blue
ZSH_HIGHLIGHT_STYLES[command]=bg=blue
ZSH_HIGHLIGHT_STYLES[precommand]=bg=blue
# ZSH_HIGHLIGHT_STYLES[commandseparator]=none
# ZSH_HIGHLIGHT_STYLES[hashed-command]=none
# ZSH_HIGHLIGHT_STYLES[path]=none
# ZSH_HIGHLIGHT_STYLES[globbing]=none
# ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
# ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
# ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
# ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
# ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
# ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
# ZSH_HIGHLIGHT_STYLES[assign]=none


# }}}
####################################################################################################
#
# Alias {{{
#

# Disable correction.
alias ack='nocorrect ack'
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias ebuild='nocorrect ebuild'
alias gcc='nocorrect gcc'
alias gist='nocorrect gist'
alias grep='nocorrect grep'
alias heroku='nocorrect heroku'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias mysql='nocorrect mysql'
alias rm='nocorrect rm'

# Disable globbing.
alias bower='noglob bower'
alias fc='noglob fc'
alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rake='noglob rake'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias sftp='noglob sftp'

# Define general aliases.
alias _='sudo'
# alias b='${(z)BROWSER}'
alias cp="${aliases[cp]:-cp} -i"
# alias e='${(z)VISUAL:-${(z)EDITOR}}'
alias ln="${aliases[ln]:-ln} -i"
alias mkdir="${aliases[mkdir]:-mkdir} -p"
alias mv="${aliases[mv]:-mv} -i"
alias p='${(z)PAGER}'
alias po='popd'
alias pu='pushd'
alias rm="${aliases[rm]:-rm} -i"
alias type='type -a'
alias which='which -a'


#
# ls commands {{{
# Base ls command
alias ls='ls --group-directories-first \
             --color=auto \
             --ignore=.DS_Store \
             --ignore=.ycm_extra_conf.pyc'

alias  l='ls -AF'                          # Lists hidden files, indicator
alias ll='ls -lhF'                         # Lists human readable sizes, show indicator
alias lr='ll -R'                           # Lists human readable sizes, recursively
alias la='ll -A'                           # Lists human readable sizes, hidden files and inode
alias lm='la | "$PAGER"'                   # Lists human readable sizes, hidden files through pager
alias lx='ll -XB'                          # Lists sorted by extension (GNU only)
alias lk='ll -Sr'                          # Lists sorted by size, largest last
alias lt='ll -tr'                          # Lists sorted by date, most recent last
alias lc='lt -c'                           # Lists sorted by date, most recent last, shows change time
alias lu='lt -u'                           # Lists sorted by date, most recent last, shows access time
alias l.='ls -ld .[a-zA-Z]*'               # Lists dotfiles only

alias sl='ls'                              # I often screw this up
alias al='la'                              # misstype

# }}}
####################################################################################################
#
# grep commands {{{
#
export GREP_COLOR='37;45'           # BSD.
export GREP_COLORS="mt=$GREP_COLOR" # GNU.

alias grep="${aliases[grep]:-grep} --color=auto"

# }}}
####################################################################################################

#
# copy and paste commands {{{
#

# Mac OS X Everywhere
if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
  # alias pbcopy='pbcopy'
  # alias pbcopy='tr -d '\n' | tee > /dev/clipboard'
elif [[ "$OSTYPE" == cygwin* ]]; then
  alias o='cygstart'
  alias pbcopy='tee > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
else
  alias o='xdg-open'

  if (( $+commands[xclip] )); then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif (( $+commands[xsel] )); then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'


# Resource Usage
alias df='df -kh'
alias du='du -kh'

if (( $+commands[htop] )); then
  alias top=htop
else
  if [[ "$OSTYPE" == (darwin*|*bsd*) ]]; then
    alias topc='top -o cpu'
    alias topm='top -o vsize'
  else
    alias topc='top -o %CPU'
    alias topm='top -o %MEM'
  fi
fi

# }}}
####################################################################################################
#
# Functions {{{
#

# Makes a directory and changes to it.
function mcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Changes to a directory and lists its contents.
function cdls {
  builtin cd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pushes an entry onto the directory stack and lists its contents.
function pushdls {
  builtin pushd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Pops an entry off the directory stack and lists its contents.
function popdls {
  builtin popd "$argv[-1]" && ls "${(@)argv[1,-2]}"
}

# Prints columns 1 2 3 ... n.
function slit {
  awk "{ print ${(j:,:):-\$${^@}} }"
}

# Finds files and executes a command on them.
function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Displays user owned processes status.
function psu {
  ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

# }}}
####################################################################################################
#
# Compdef {{{
#

autoload -Uz make n
compdef n=nvim

# }}}
####################################################################################################
if [[ -n $ZSH_DEBUG ]]; then; echo 'Finished $HOME/.zshrc'; fi
