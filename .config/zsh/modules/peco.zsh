#
# peco {{{
#

# -----------------------------------------------------------------------------
# History search {{{
#  - Search shell history with peco
#  - Adapted from: https://github.com/mooz/percol#zsh-history-search
#  - https://gist.github.com/jimeh/7d94f1000cfc9cba2893
function peco_select_history() {
  BUFFER=$(fc -l -n 1| gtac | peco --query "$LBUFFER")
  CURSOR=$#BUFFER  # move cursor
  zle clear-screen # refresh
}
zle -N peco_select_history
bindkey '^r' peco_select_history
bindkey '^z^r' history-incremental-search-backward

# }}}
# -----------------------------------------------------------------------------
# ghq {{{
#   - http://weblog.bulknews.net/post/89635306479/ghq-peco-percol
function peco_ghq() {
    local SELECTED_DIR=$(GIT_CONFIG=~/.config/ghq/.gitconfig ghq list -p | peco)
    if [ -n "$SELECTED_DIR" ]; then
        BUFFER="cd ${SELECTED_DIR}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco_ghq
bindkey '^q' peco_ghq

# ssh
function peco_ssh() {
  # ssh $(awk 'tolower($1)=="host" {for (i=2; i<=NF; i++) {if ($i !~ "[*?]") {print $i}}}' ~/.ssh/config | grep -v '127.0.0.1' | sort | peco)
  BUFFER="ssh $(awk 'tolower($1)=="host" {for (i=2; i<=NF; i++) {if ($i !~ "[*?]") {print $i}}}' ~/.ssh/config | grep -v '127.0.0.1' | sort | peco --query "$LBUFFER")"
  CURSOR=$#BUFFER  # move cursor
  zle clear-screen # refresh
}
zle -N peco_ssh
# bindkey '^s' peco_ssh
# alias peco_ssh='peco-ssh'

# }}}
# -----------------------------------------------------------------------------
# peco + godoc {{{
# http://syohex.hatenablog.com/entry/20140620/1403257070
function pecodoc() {
    local -a go_packages

    go_packages=("builtin")
    for dir in $GOROOT $(perl -wle 'print $_ for split q{:}, shift' $GOPATH)
    do
        pkgdir="$dir/pkg"
        if [ -d $pkgdir ]; then
            packages=$(find $pkgdir -name "*.a" -type f \
                       | perl -wlp -e "s{$pkgdir/(?:(?:obj|tool)/)?[^/]+/}{} and s{\\.a\$}{}")
            go_packages=($packages $go_packages)
        fi
    done

    command godoc $(echo $go_packages | sort | uniq | peco) | $PAGER
}

# }}}
# -----------------------------------------------------------------------------
[[ $ZSH_DEBUG = '1' ]] && echo 'Finished $HOME/.zsh/modules/peco.zsh'
# vim:ft=zsh:sts=2:sw=2:ts=2:et
