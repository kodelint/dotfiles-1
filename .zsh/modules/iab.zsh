setopt EXTENDED_GLOB

typeset -A abbreviations
abbreviations=(
  "A"    "| ag"
  "C"    "\`ls | cho\`"
  "D"    "--debug"
  "G"    "| grep"
  "H"    "| pt"
  "L"    "| less"
  "N"    "> /dev/null 2>&1"
  "P"    "| pbcopy"
  "S"    "| sed"
  "T"    "| tail"
  # "W"    "| wc"
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
####################################################################################################
if [[ -n $ZSH_DEBUG ]]; then; echo 'Finished $HOME/.zsh/modules/iab.zsh'; fi
