# function.zsh {{{
# Defines zsh functions
if [[ -n $ZSH_DEBUG ]]; then; echo 'DEBUG: Loading $HOME/.zsh/modules/function.zsh...'; fi
###################################################################################################


# Makes a directory and changes to it.
function mcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

# Displays user owned processes status.
function psu {
  ps -U "${1:-$LOGNAME}" -o 'pid,%cpu,%mem,command' "${(@)argv[2,-1]}"
}

# Compile and restart zshrc
function ex {
  # Remove old .zcompdump
  command rm -f $HOME/.zcompdump $HOME/.zcompdump.zwc

  # Load compinit and zrecompile, and generate .zcompdump
  autoload -Uz compinit zrecompile; compinit

  local zsh_sources=(
    $HOME/.zshenv
    $HOME/.zshrc
    $HOME/.zsh/alias.zsh
    $HOME/.zsh/completion.zsh
    $HOME/.zsh/dirhash.zsh
    $HOME/.zsh/function.zsh
    $HOME/.zsh/prompt.zsh
    $HOME/.zsh/history.zsh
    $HOME/.zsh/key-bindings.zsh
    $HOME/.zsh/modules/brew.zsh
    $HOME/.zsh/modules/docker.zsh
    $HOME/.zsh/modules/git.zsh
    $HOME/.zsh/modules/iab.zsh
    $HOME/.zsh/modules/ls_abbrev.zsh
    $HOME/.zsh/modules/peco.zsh
    $HOME/.zcompdump 
  )

  for f in $zsh_sources; do
    [[ $f -nt $f.zwc ]] && zrecompile -p $f && command rm -f $f.zwc.old
    ! [[ -s $f.zwc ]] && zcompile $f
  done

  # local zcdump_file="$HOME/.zcompdump"
  # local old_zcdump_size=$(/opt/coreutils/bin/du -b "$zcdump_file" | cut -f1)
  # compinit -i -d $zcdump_file
  #
  # local new_zcdump_size=$(/opt/coreutils/bin/du -b "$zcdump_file" | cut -f1)
  #
  # [[ $new_zcompdump_size -gt $old_zcompdump_size ]] && zrecompile -p $zcdump_file && command rm -f $zcdump_file.zwc.old
  # ! [[ -s $zcdump_file.zwc ]] && zcompile $zcdump_file

  # Restart zsh
  exec -l $SHELL
}

# }}}
###################################################################################################
[[ -n $ZSH_DEBUG ]] && echo 'DEBUG: Finished $HOME/.zsh/modules/function.zsh'
