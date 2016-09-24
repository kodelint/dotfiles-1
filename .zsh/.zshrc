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

source "$ZSH_MODULE/brew.zsh"
source "$ZSH_MODULE/docker.zsh"
source "$ZSH_MODULE/git.zsh"
source "$ZSH_MODULE/iab.zsh"
source "$ZSH_MODULE/ls_abbrev.zsh"
source "$ZSH_MODULE/peco.zsh"

source "$ZSH_PLUGIN/zsh-users/zsh-completions/zsh-completions.plugin.zsh"
source "$ZSH_PLUGIN/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

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
zstyle ':z:load' zfunction 'mcd' 'n' 'nv' 'date' 'cmakeclean' 'cd' 'man' 'jman' 'findcomp' 'findsymlink' 'shasumcheck' 'unsetm' 'mangrep' 'echoenv' 'tree' 'gen'
zstyle -a ':z:load' zfunction 'zfunctions'
for zfunction ("$zfunctions[@]") autoload -Uz "$zfunction"
unset zfunction{s,}

sumcheck() { curl -L --silent $1 | shasum -a 256 | awk '{print $1}' }
unsetm() {for e in $(env | grep -E "^$1" | awk -F = '{print $1}'); do unset $e; done}

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
HISTSIZE=5000000000000            # Memory History size
SAVEHIST=10000000000000           # Save History size
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
ZSH_HIGHLIGHT_HIGHLIGHTERS=(brackets cursor line main pattern root)
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
if [[ -n $ZSH_DEBUG ]]; then; echo 'Finished $HOME/.zshrc'; fi

# Evaluate system PATH
if [ -x /usr/libexec/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi
