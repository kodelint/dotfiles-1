#
# .zshrc {{{
# Executes commands at the start of an interactive session.
#

if [[ -n $ZSH_DEBUG ]]; then; echo 'Loading $HOME/.zshrc'; fi

# }}}
###################################################################################################

# Load local modules

source "$HOME/.zsh/alias.zsh"
source "$HOME/.zsh/completion.zsh"
source "$HOME/.zsh/dirhash.zsh"
source "$HOME/.zsh/function.zsh"
source "$HOME/.zsh/history.zsh"
source "$HOME/.zsh/key-bindings.zsh"
source "$HOME/.zsh/prompt.zsh"
source "$HOME/.zsh/zcompile.zsh"

source "$ZSH_MODULE/brew.zsh"
source "$ZSH_MODULE/docker.zsh"
source "$ZSH_MODULE/git.zsh"
source "$ZSH_MODULE/iab.zsh"
source "$ZSH_MODULE/ls_abbrev.zsh"
source "$ZSH_MODULE/peco.zsh"

source "$ZSH_PLUGIN/zsh-users/zsh-completions/zsh-completions.plugin.zsh"
source "$ZSH_PLUGIN/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/go/src/github.com/suzaku/shonenjump/scripts/shonenjump.zsh"

# }}}
###################################################################################################

# Terminal settings

stty -ixon
stty -iutf8
stty speed 115200 > /dev/null

# }}}
###################################################################################################

# Zsh Global {{{

# Set the Zsh modules to load (man zshmodules)
# Load Zsh modules
zstyle ':z:load' zmodule 'zsh/attr' 'zsh/stat' 'zsh/pcre' 'zsh/net/socket' 'zsh/db/gdbm'
zstyle -a ':z:load' zmodule 'zmodules'
for zmodule ("$zmodules[@]") zmodload "${(z)zmodule}"
unset zmodule{s,}

# Set the Zsh functions to load (man zshcontrib)
# Autoload Zsh functions
zstyle ':z:load' zfunction 'mcd' 'make' 'n' 'nv' 'date' 'cclean' 'cd' 'man' 'jman' 'findcomp' 'shasumcheck' 'unsetm' 'mangrep' 'echoenv'
zstyle -a ':z:load' zfunction 'zfunctions'
for zfunction ("$zfunctions[@]") autoload -Uz "$zfunction"
unset zfunction{s,}

sumcheck() { curl -L --silent $1 | shasum -a 256 | awk '{print $1}' }
unsetm() {for e in $(env | grep -E "^$1" | awk -F = '{print $1}'); do unset $e; done}

# Import Apple default /etc/zshrc
# Correctly display UTF-8 with combining characters.
if [ "$TERM_PROGRAM" = "Apple_Terminal" ]; then
  setopt combiningchars
fi

REPORTTIME=3               # Output zsh command response
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
###################################################################################################
#
# Zsh history {{{
#

HISTFILE=~/.zsh_history
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
ZSH_HIGHLIGHT_STYLES[default]=fg=none
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
###################################################################################################

# Setup languages environment

# https://github.com/uu59/dotfiles/commit/d75703d89abfc9186453d692c538fc4180c124fc#diff-ae10adf7d754267f81b8c2d70835a5eeR41
# rbenv
# if [ $+commands[rbenv] -ne 0 ]; then
#   rbenv_init(){
#     export PATH="/usr/local/var/rbenv/shims:${PATH}"
#     export RBENV_SHELL=zsh
#     source '/usr/local/Cellar/rbenv/1.0.0/libexec/../completions/rbenv.zsh'
#     rbenv() {
#       local command
#       command="$1"
#       if [ "$#" -gt 0 ]; then
#         shift
#       fi
#
#       case "$command" in
#         rehash|shell)
#           eval "$(rbenv "sh-$command" "$@")";;
#         *)
#           command rbenv "$command" "$@";;
#       esac
#     }
#   }
#   rbenv_init
#   unfunction rbenv_init
# fi
#
# if (( $+commands[pyenv] )); then
#   pyenv_init(){
#     export PATH="/Users/zchee/.pyenv/shims:${PATH}"
#     export PYENV_SHELL=zsh
#     source "${HOME}/.pyenv/completions/pyenv.zsh"
#     # command pyenv rehash 2>/dev/null
#     pyenv() {
#       local command
#       command="$1"
#       if [ "$#" -gt 0 ]; then
#         shift
#       fi
#
#       case "$command" in
#         activate|deactivate|rehash|shell)
#           eval "$(pyenv "sh-$command" "$@")";;
#         *)
#           command pyenv "$command" "$@";;
#       esac
#     }
#     export PATH="/Users/zchee/.pyenv/plugins/pyenv-virtualenv/shims:${PATH}";
#     export PYENV_VIRTUALENV_INIT=1;
#     _pyenv_virtualenv_hook() {
#       local ret=$?
#       if [ -n "$VIRTUAL_ENV" ]; then
#         eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
#       else
#         eval "$(pyenv sh-activate --quiet || true)" || true
#       fi
#       return $ret
#     };
#     typeset -g -a precmd_functions
#     if [[ -z $precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
#       precmd_functions=(_pyenv_virtualenv_hook $precmd_functions);
#     fi
#   }
#   pyenv_init
#   unfunction pyenv_init
# fi

# }}}
###################################################################################################

# Online zsh help?
if [[ $(type -w run-help) == "run-help: alias" ]]; then
  unalias run-help
fi
autoload run-help
export HELPDIR=/usr/local/share/zsh/help

# }}}
###################################################################################################
if [[ -n $ZSH_DEBUG ]]; then; echo 'Finished $HOME/.zshrc'; fi
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/Users/zchee/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
