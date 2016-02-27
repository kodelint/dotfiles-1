# neovim
# alias n="nvim $@"
# alias no="nvim -p $@"
# config file alias
alias nv="${EDITOR} ${HOME}/.config/nvim/init.vim"
alias nvr="nvim -c 'UpdateRemotePlugins' -c 'q' >/dev/null; cat ${HOME}/.nvim/.init.vim-rplugin\~"
alias tm="${EDITOR} ${HOME}/.tmux.conf"
alias irrc="${EDITOR} ${HOME}/.irssi/config"

# Go
alias b='gb'

# Python
alias py='python3'
alias py2='python2'
alias py3='python3'
alias pi='pip3'

# Build
alias nj="ninja"

# brew
alias brew='CURL_CA_BUNDLE= brew'
alias brwif='brew info'
alias brews='brew list -1'
alias brwC='brew cleanup --force'
alias brwU='brew uninstall'
alias brwc='brew cleanup'
alias brwi='brew install'
alias brwl='brew list'
alias brws='brew search'
alias brwu='brew update && brew upgrade --all'
alias brwx='brew remove'
alias bubc='brew upgrade && brew cleanup'
alias bubo='brew update && brew outdated'
alias cask='brew cask'
alias caskC='brew cask cleanup'
alias caskc='brew cask cleanup --outdated'
alias caski='brew cask install'
alias caskl='brew cask list'
alias casks='brew cask search'
alias caskx='brew cask uninstall'

# Tools
alias c='ccat --bg=dark'
alias irssi='TERM=screen-256color irssi'
alias tvi="${HOME}/bin/travis"
alias get='ghq get -u'
alias diff='git diff'
alias ipython='ipython --matplotlib=auto'
alias htop='sudo htop'

# Clipboard
alias path='echo -n `pwd` | pbcopy'


# man() {
# env \
#     LESS_TERMCAP_mb=$(printf "\e[1;31m") \
#     LESS_TERMCAP_md=$(printf "\e[1;31m") \
#     LESS_TERMCAP_me=$(printf "\e[0m") \
#     LESS_TERMCAP_se=$(printf "\e[0m") \
#     LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
#     LESS_TERMCAP_ue=$(printf "\e[0m") \
#     LESS_TERMCAP_us=$(printf "\e[1;32m") \
#     PAGER="${commands[less]:-$PAGER}" \
#     _NROFF_U=1 \
#     PATH="$HOME/bin:$PATH" \
#     man "$@"
# }
