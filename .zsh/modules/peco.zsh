#
# peco {{{
#

# History search
#  - Search shell history with peco
#  - Adapted from: https://github.com/mooz/percol#zsh-history-search
#  - https://gist.github.com/jimeh/7d94f1000cfc9cba2893
function peco_select_history() {
  BUFFER=$(fc -l -n 1| tac | peco --query "$LBUFFER")
  CURSOR=$#BUFFER  # move cursor
  zle clear-screen # refresh
}
zle -N peco_select_history
bindkey '^r' peco_select_history
bindkey '^z^r' history-incremental-search-backward

# Go
# function peco-go() {
#   local SELECTED_DIR=$(golist | peco)
#   if [ -n "$SELECTED_DIR" ]; then
#     BUFFER="cd ${SELECTED_DIR}"
#     zle accept-line
#   fi
#   zle clear-screen
# }
# zle -N peco-go
# bindkey '^z^g' peco-go

# ghq
#   - http://weblog.bulknews.net/post/89635306479/ghq-peco-percol
function peco-ghq() {
    local SELECTED_DIR=$(GIT_CONFIG=~/.config/ghq/.gitconfig ghq list -p | peco)
    if [ -n "$SELECTED_DIR" ]; then
        BUFFER="cd ${SELECTED_DIR}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-ghq
bindkey '^q' peco-ghq

# ssh
function peco-ssh() {
  ssh $(awk 'tolower($1)=="host" {for (i=2; i<=NF; i++) {if ($i !~ "[*?]") {print $i}}}' ~/.ssh/config | grep -v '127.0.0.1' | sort | peco)
}
alias s='peco-ssh'

# }}}
####################################################################################################
if [[ -n $ZSH_DEBUG ]]; then; echo 'Finished $HOME/.zsh/modules/peco.zsh'; fi
