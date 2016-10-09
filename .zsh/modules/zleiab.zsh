# zleiab {{{
# vim like abbreviation
# zshwiki.org: http://zshwiki.org/home/examples/zleiab

setopt EXTENDED_GLOB

typeset -A abbreviations
abbreviations=(
  "A"    "| awk"
  "D"    "--debug"
  "G"    "| grep"
  "H"    "| pt"
  "L"    "| less"
  "N"    "> /dev/null 2>&1"
  "P"    "| pbcopy"
  "S"    "| sed"
  "T"    "| tail"
  "W"    "| wc -l"
  "V"    "V=1"
  "X"    "| xargs"
)

magic-abbrev-expand() {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9]#}
  LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
  zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

# }}}
# -----------------------------------------------------------------------------
[[ $ZSH_DEBUG = '1' ]] && echo 'Finished $HOME/.zsh/modules/zleiab.zsh'
# vim:ft=zsh:sts=2:sw=2:ts=2:et
