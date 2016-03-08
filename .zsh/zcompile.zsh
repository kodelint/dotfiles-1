# Init
autoload -Uz zrecompile

#
# Zsh configuration file
#
[[ $HOME/.zsh/alias.zsh -nt $HOME/.zsh/alias.zsh.zwc ]] && zrecompile -p $HOME/.zsh/alias.zsh && rm -f $HOME/.zsh/alias.zsh.zwc.old
[[ $HOME/.zsh/completion.zsh -nt $HOME/.zsh/completion.zsh.zwc ]] && zrecompile -p $HOME/.zsh/completion.zsh && rm -f $HOME/.zsh/completion.zsh.zwc.old
[[ $HOME/.zsh/dirhash.zsh -nt $HOME/.zsh/dirhash.zsh.zwc ]] && zrecompile -p $HOME/.zsh/dirhash.zsh && rm -f $HOME/.zsh/dirhash.zsh.zwc.old
[[ $HOME/.zsh/function.zsh -nt $HOME/.zsh/function.zsh.zwc ]] && zrecompile -p $HOME/.zsh/function.zsh && rm -f $HOME/.zsh/function.zsh.zwc.old
[[ $HOME/.zsh/prompt.zsh -nt $HOME/.zsh/prompt.zsh.zwc ]] && zrecompile -p $HOME/.zsh/prompt.zsh && rm -f $HOME/.zsh/prompt.zsh.zwc.old
[[ $HOME/.zsh/history.zsh -nt $HOME/.zsh/history.zsh.zwc ]] && zrecompile -p $HOME/.zsh/history.zsh && rm -f $HOME/.zsh/history.zsh.zwc.old
[[ $HOME/.zsh/key-bindings.zsh -nt $HOME/.zsh/key-bindings.zsh.zwc ]] && zrecompile -p $HOME/.zsh/key-bindings.zsh && rm -f $HOME/.zsh/key-bindings.zsh.zwc.old
[[ $HOME/.zsh/prompt.zsh -nt $HOME/.zsh/prompt.zsh.zwc ]] && zrecompile -p $HOME/.zsh/prompt.zsh && rm -f $HOME/.zsh/prompt.zsh.zwc.old
[[ $HOME/.zsh/utility.zsh -nt $HOME/.zsh/utility.zsh.zwc ]] && zrecompile -p $HOME/.zsh/utility.zsh && rm -f $HOME/.zsh/utility.zsh.zwc.old
[[ $HOME/.zsh/zcompile.zsh -nt $HOME/.zsh/zcompile.zsh.zwc ]] && zrecompile -p $HOME/.zsh/zcompile.zsh && rm -f $HOME/.zsh/zcompile.zsh.zwc.old

[[ $HOME/.zshenv -nt $HOME/.zshenv.zwc ]] && zrecompile -p $HOME/.zshenv && . $HOME/.zshenv && rm -f $HOME/.zshenv.zwc.old
[[ $HOME/.zshrc -nt $HOME/.zshrc.zwc ]] && zrecompile -p $HOME/.zshrc && . $HOME/.zshrc && rm -f $HOME/.zshrc.zwc.old
[[ $HOME/.zprofile -nt $HOME/.zprofile.zwc ]] && zrecompile -p $HOME/.zprofile && . $HOME/.zprofile && rm -f $HOME/.zprofile.zwc.old

#
# Zsh function
#
# local ZSH_FUNC_PATH="${HOME}/.zsh"
# for ZSH_FUNC ($ZSH_FUNC_PATH/*.zsh);
# do
#   [[ $ZSH_FUNC_PATH/$ZSH_FUNC -nt $ZSH_FUNC_PATH/$ZSH_FUNC.zwc ]] &&\
#    zrecompile -p $ZSH_FUNC_PATH/$ZSH_FUNC &&\
#   . $ZSH_FUNC_PATH/$ZSH_FUNC.zwc
# done
