# Change directory with auto ls
# -A : Do not show . and ..
# -C : Force multi-column output.
# -F : Append indicator (one of */=>@|) to entries.\
function ls_abbrev {
  if hash gls; then
    local cmd_ls='gls'
  else
    local cmd_ls='gls'
  fi
  local -a opt_ls
  opt_ls=('-ACF' '--group-directories-first' '--color=always' '--ignore=.DS_Store' '--ignore=.ycm_extra_conf.pyc')

  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

  if [ $ls_lines -gt 10 ]; then
      echo "$ls_result\n" | head -n 5
      echo '...'
      echo "$ls_result\n" | tail -n 5
      echo "$(command $cmd_ls -1 -A | wc -l | tr -d ' ') files exist"
  else
      echo "$ls_result\n"
  fi
}
autoload -Uz add-zsh-hook ls_abbrev
add-zsh-hook chpwd ls_abbrev

# }}}
####################################################################################################
if [[ -n $ZSH_DEBUG ]]; then; echo 'Finished $HOME/.zsh/modules/ls_abbrev.zsh'; fi
