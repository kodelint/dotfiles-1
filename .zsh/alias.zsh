#
# Alias {{{
#

# Disable correction.
alias ack='nocorrect ack'
# alias cd='nocorrect cd'
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
alias po='popd'
alias pu='pushd'
alias rm="${aliases[rm]:-rm} -i"
alias type='type -a'
alias which='which -a'

# }}}
####################################################################################################
#
# ls commands {{{
#

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
alias wh='which'

# }}}
####################################################################################################
#
# grep commands {{{
#

alias grep="${aliases[grep]:-grep} --color=auto"

# }}}
####################################################################################################

#
# copy and paste commands {{{
#

# Mac OS X Everywhere
if [[ "$OSTYPE" == darwin* ]]; then
  alias o='open'
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

# alias pbc='pbcopy'
# alias pbp='pbpaste'


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
# -------------------------------------------------------------------------------------------------
# Languages

# Go
# alias b='gb'

# Python
alias nose='nosetests'
# if [[ -d "/opt/intel/intelpython27" ]]; then
if [[ $(command type python | awk '{print $3}') == "/opt/intel/intelpython27/bin/python" ]]; then
  alias python='/opt/intel/intelpython27/bin/python'
  alias pip2='/opt/intel/intelpython27/bin/pip2 --disable-pip-version-check'
fi
# if [[ -d "/opt/intel/intelpython35" ]]; then
if [[ $(command type python3 | awk '{print $3}') == "/opt/intel/intelpython35/bin/python3" ]]; then
  alias python='/opt/intel/intelpython35/bin/python3'
  alias python3='/opt/intel/intelpython35/bin/python3'
  alias pip='/opt/intel/intelpython35/bin/pip3 --disable-pip-version-check'
  alias pip3='/opt/intel/intelpython35/bin/pip3 --disable-pip-version-check'
else
  alias python='python3'
  alias pip='pip3'
fi

# Build
alias mk="make"
alias nj="ninja"

# Unix commands
alias pss="ps | awk 'NR>1 {print}' | grep -v awk | grep -v sort | sort"

# Clipboard
alias path='echo -n `pwd` | pbcopy'

# Darwin kernel layer
alias jt='jtool'
alias prox='procexp'

# Tool
alias aria='aria2c'
alias ccat='ccat --bg=dark'
alias diff='git diff'
alias get='ghq get -u'
alias htop='sudo htop'
alias ipython='ipython --matplotlib=auto'
alias irssi='TERM=screen-256color irssi'
alias p='pt'
alias juc='jupyter console'
alias pg='pgrep'
alias pk='pkill'
alias pbc='command pbcopy'
alias t='gotail'

# config file alias
alias nru="nvim -c 'call dein#clear_state() | call dein#clear_cache()' -c 'UpdateRemotePlugins' -c 'q' >/dev/null; cat ${HOME}/.nvim/.init.vim-rplugin\~"
alias tm="${EDITOR} ${HOME}/.tmux.conf"

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
