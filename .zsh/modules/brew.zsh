#
# Aliases
#

# Homebrew
alias brwc='brew cleanup'
alias brwC='brew cleanup --force'
alias brwi='brew install'
alias brwl='brew list'
alias brws='brew search'
alias brwu='brew update && brew upgrade --all'
alias brwU='brew uninstall'
alias brwx='brew remove'

# Homebrew Cask
alias cask='brew cask'
alias caskc='brew cask cleanup --outdated'
alias caskC='brew cask cleanup'
alias caski='brew cask install'
alias caskl='brew cask list'
alias casks='brew cask search'
alias caskx='brew cask uninstall'

# }}}
####################################################################################################
if [[ -n $ZSH_DEBUG ]]; then; echo 'Finished $HOME/.zsh/modules/brew.zsh'; fi
