#
# function.zsh {{{
# Defines zsh functions
#
if [[ -n $ZSH_DEBUG ]]; then; echo 'DEBUG: Loading $HOME/.zsh/modules/function.zsh...'; fi


# Compile and restart zshrc
function ex()
{
  # Remove old .zcompdump
  # command rm -f $HOME/.zcompdump $HOME/.zcompdump.zwc
  # Load compinit and zrecompile, and generate .zcompdump
  # autoload -Uz compinit zrecompile; compinit

  # Compiling each of zsh configuration file
  # for f in $HOME/.zshenv $HOME/.zshrc $HOME/.zprofile $HOME/.zcompdump; do
  #   zrecompile -p $f && command rm -f $f.zwc.old
  # done

  # Restart zsh
  exec $SHELL
}


# }}}
################################################################################
if [[ -n $ZSH_DEBUG ]]; then; echo 'DEBUG: Finished $HOME/.zsh/modules/function.zsh'; fi
