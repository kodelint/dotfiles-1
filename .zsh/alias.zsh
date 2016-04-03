# neovim
# alias n="nvim $@"
# alias no="nvim -p $@"
# config file alias
alias nv="${EDITOR} ${HOME}/.config/nvim/init.vim"
alias nvr="nvim -c 'call dein#clear_state() | call dein#clear_cache()' -c 'UpdateRemotePlugins' -c 'q' >/dev/null; cat ${HOME}/.nvim/.init.vim-rplugin\~"
alias nvd="nvim -c 'call dein#update()' -c 'qall!'; cat ${HOME}/.nvim/.init.vim-rplugin\~"
alias tm="${EDITOR} ${HOME}/.tmux.conf"

# Languages
# Go
# alias b='gb'

# Python
alias py='python3'
alias py2='python2'
alias py3='python3'
if [[ $(which pip2) == "/opt/intel/intelpython27/bin/pip2" ]]; then
  alias pip='pip --disable-pip-version-check'
fi
if [[ $(which pip3) == "/opt/intel/intelpython35/bin/pip3" ]]; then
  alias pip='pip3'
  alias pip3='pip3 --disable-pip-version-check'
else
  alias pip='pip2' # lock python2
fi

# Build
alias nj="ninja"

# Darwin kernel layer commands
alias jt='jtool'
alias prox='procexp'

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
alias ag="ag --color-match '37;45'"
alias aria='aria2c'
alias c='ccat --bg=dark'
alias irssi='TERM=screen-256color irssi'
alias tvi="${HOME}/bin/travis"
alias get='ghq get -u'
alias diff='git diff'
alias ipython='ipython --matplotlib=auto'
alias htop='sudo htop'
alias pbc='| tr -d "\n" | pbcopy'

# Clipboard
alias path='echo -n `pwd` | pbcopy'

# Utility
sumcheck() { curl -L --silent $1 | shasum -a 256 | awk '{print $1}' }
