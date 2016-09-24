#
# Zsh completions {{{
#
# cf: https://github.com/seebi/zshrc/blob/master/completion.zsh
#

# ----------------------------------------------------------------------------
# compinit

autoload -Uz compinit zrecompile; compinit
source /usr/local/share/zsh/site-functions/_aws

# add an autoload function path, if directory exists
# http://www.zsh.org/mla/users/2002/msg00232.html
functionsd="$ZSH_CONFIG/functions.d"
if [[ -d "$functionsd" ]] {
    fpath=( $functionsd $fpath )
    autoload -U $functionsd/*(:t)
}


# ----------------------------------------------------------------------------
# Load completions system
zmodload -i zsh/complist

setopt ALWAYS_TO_END       # Move cursor to the end of a completed word
setopt AUTO_LIST           # Automatically list choices on ambiguous completion
setopt AUTO_MENU           # Show completion menu on a successive tab press
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash
setopt CASE_GLOB
setopt COMPLETE_IN_WORD    # Complete from both ends of a word
setopt PATH_DIRS           # Perform path search even on command names with slashes
unsetopt MENU_COMPLETE     # Autoselect the first completion entry
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor


zstyle ':completion:*'    accept-exact '*(N)'
zstyle ':completion:*'    complete-options true
zstyle ':completion:*'    group-name '' # for all completions: grouping the output
zstyle ':completion:*'    list-colors ${(s.:.)LS_COLORS} # for all completions: color
zstyle ':completion:*'    matcher-list 'm:{a-z}={A-Z}' # case insensitivity 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*'    rehash true # auto rehash commands http://www.zsh.org/mla/users/2011/msg00531.html
zstyle ':completion:*'    verbose yes

# Group matches and describe format
zstyle ':completion:*'                  format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:*:*:*:*'          menu select=2 # for all completions: menuselection
zstyle ':completion:*:default'          list-prompt '%S%M matches%s'
zstyle ':completion:*:corrections'      format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions'     format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:matches'          group 'yes'
zstyle ':completion:*:messages'         format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings'         format ' %F{red}-- no matches found --%f'

zstyle ':completion:*:options'          auto-description '%d'
zstyle ':completion:*:options'          description 'yes'

# Caching coompletion results
zstyle ':completion::complete:*'        cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
zstyle ':completion::complete:*'        use-cache on


# Fuzzy match mistyped completions
zstyle ':completion:*'                  completer _complete _match _approximate
zstyle ':completion:*:match:*'          original only
zstyle ':completion:*:approximate:*'    max-errors 1 numeric


# Increase the number of errors based on the length of the typed word
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'


# Don't complete unavailable commands
zstyle ':completion:*:functions'        ignored-patterns '(_*|pre(cmd|exec))'


# Array completion element sorting
zstyle ':completion:*:*:-subscript-:*'  tag-order indexes parameters


# Directories
zstyle ':completion:*:default'                list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*'                 tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*'                 ignored-patterns '(*/)#lost+found' parent pwd
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*'              group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*'                        squeeze-slashes true


# History
zstyle ':completion:*:history-words'    stop yes
zstyle ':completion:*:history-words'    remove-all-dups yes
zstyle ':completion:*:history-words'    list false
zstyle ':completion:*:history-words'    menu yes


# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}


# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'


# Ignore patterns
#
# Vcs
# Compiler
# Zsh
# OS X
# tags
# Python byte-compile & cache
# visual studio code
# delve debug byinary
zstyle ':completion:*:*files' ignored-patterns \
  '.git' '.hg' '.svn' \
  \
  '*?.aux' '*?.out' '*?.so' \
  '*?.toc' \
  '*?.snm' \
  '*?.nav' \
  '*?.pdf' \
  \
  '*?.zwc' \
  \
  '*.DS_Store' \
  '*tags' \
  '*?.pyc' \
  '__pycache__' \
  '.vscode' \
  'LICENSE' \
  '*?~' \
  '*\#'

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'


# unless we really want to.
zstyle '*' single-ignored show


# Ignore multiple entries
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'


# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single


# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true


# ssh/scp/rsync
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
# }}}
# -------------------------------------------------------------------------------------------------
# Load compdef
source ${HOME}/.zsh/compdef.zsh
