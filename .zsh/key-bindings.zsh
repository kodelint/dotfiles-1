#
# key-bindings.zsh {{{
# Defines zsh bindkey
#

#
# Variables
#

# Treat these characters as part of a word.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Use human-friendly identifiers.
zmodload zsh/terminfo
typeset -gA key_info
key_info=(
  'Escape'       '\e'
  'Up'           "^[[A"
  'Down'         "^[[B"
  'Right'        "^[[C"
  'Left'         "^[[D"
  'Control'      '\C-'
  'C-Up'         '^[[1;5A'
  'C-Down'       '^[[1;5B'
  'C-Right'      '^[[1;5C'
  'C-Left'       '^[[1;5D'
  'Meta'         '\M-'
  'Backspace'    "^?"
  'Delete'       "^[[3~"
  'S-Up'         "^[[1;2A"
  'S-Down'       "^[[1;2B"
  'S-Right'      "^[[1;2C"
  'S-Left'       "^[[1;2D"
  'S-Tab'        "^[[1;2Z"
  'F1'           "$terminfo[kf1]"
  'F2'           "$terminfo[kf2]"
  'F3'           "$terminfo[kf3]"
  'F4'           "$terminfo[kf4]"
  'F5'           "$terminfo[kf5]"
  'F6'           "$terminfo[kf6]"
  'F7'           "$terminfo[kf7]"
  'F8'           "$terminfo[kf8]"
  'F9'           "$terminfo[kf9]"
  'F10'          "$terminfo[kf10]"
  'F11'          "$terminfo[kf11]"
  'F12'          "$terminfo[kf12]"
  'Insert'       "$terminfo[kich1]"
  'Home'         "$terminfo[khome]"
  'PageUp'       "$terminfo[kpp]"
  'End'          "$terminfo[kend]"
  'PageDown'     "$terminfo[knp]"
  'BackTab'      "$terminfo[kcbt]"
)

bindkey -e                                            # Use emacs key bindings

bindkey "$key_info[Up]"   up-line-or-search           # start typing + [Up-Arrow] - fuzzy find history forward
bindkey "$key_info[Down]" down-line-or-search         # start typing + [Down-Arrow] - fuzzy find history backward

bindkey ' ' magic-space                               # [Space] - do history expansion

# bindkey "$key_info[C-Up]" forward-word             # [Ctrl-RightArrow] - move forward one word
# bindkey "$key_info[C-Down]"  backward-word            # [Ctrl-LeftArrow] - move backward one word
bindkey "$key_info[C-Right]" forward-word             # [Ctrl-RightArrow] - move forward one word
bindkey "$key_info[C-Left]"  backward-word            # [Ctrl-LeftArrow] - move backward one word
# bindkey '^[[1;5D' backward-word
bindkey "$key_info[S-Right]" forward-word             # [Ctrl-RightArrow] - move forward one word
bindkey "$key_info[S-Left]"  backward-word            # [Ctrl-LeftArrow] - move backward one word

bindkey "${terminfo[kcbt]}"   reverse-menu-complete   # [Shift-Tab] - move through the completion menu backwards

bindkey '^?' backward-delete-char                     # [Backspace] - delete backward
bindkey "$key_info[Delete]" delete-char               # [Delete] - delete forward

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# file rename magick
bindkey "^[m" copy-prev-shell-word


function edit-command-line() {
  tmpfile=$(mktemp -t zsheditXXXXXXXX.sh)
  print -R - "$PREBUFFER$BUFFER" >> $tmpfile
  editor=${VISUAL:-${EDITOR:-vi}}
  args=()
  if [[ "$editor" =~ vim ]]; then
    pb=${#PREBUFFER}
    (( b=pb+CURSOR ))
    args+=("-c" ":call cursor(byte2line($b), ($b - $pb) + 1)")
  fi
  args+=($tmpfile)
  exec </dev/tty
  $editor ${args[@]}
  print -z - "$(<$tmpfile)"
  command rm -f $tmpfile
  zle send-break
}
bindkey '^F' edit-command-line
zle -N edit-command-line

#
# Functions
#

# # Exposes information about the Zsh Line Editor via the $editor_info associative
# # array.
# function editor-info {
#   # Clean up previous $editor_info.
#   unset editor_info
#   typeset -gA editor_info
#
#   if [[ "$KEYMAP" == 'vicmd' ]]; then
#     zstyle -s ':prezto:module:editor:info:keymap:alternate' format 'REPLY'
#     editor_info[keymap]="$REPLY"
#   else
#     zstyle -s ':prezto:module:editor:info:keymap:primary' format 'REPLY'
#     editor_info[keymap]="$REPLY"
#
#     if [[ "$ZLE_STATE" == *overwrite* ]]; then
#       zstyle -s ':prezto:module:editor:info:keymap:primary:overwrite' format 'REPLY'
#       editor_info[overwrite]="$REPLY"
#     else
#       zstyle -s ':prezto:module:editor:info:keymap:primary:insert' format 'REPLY'
#       editor_info[overwrite]="$REPLY"
#     fi
#   fi
#
#   unset REPLY
#
#   zle reset-prompt
#   zle -R
# }
# zle -N editor-info
#
# # Updates editor information when the keymap changes.
# function zle-keymap-select {
#   zle editor-info
# }
# zle -N zle-keymap-select
#
# # Enables terminal application mode and updates editor information.
# function zle-line-init {
#   # The terminal must be in application mode when ZLE is active for $terminfo
#   # values to be valid.
#   if (( $+terminfo[smkx] )); then
#     # Enable terminal application mode.
#     echoti smkx
#   fi
#
#   # Update editor information.
#   zle editor-info
# }
# zle -N zle-line-init
#
# # Disables terminal application mode and updates editor information.
# function zle-line-finish {
#   # The terminal must be in application mode when ZLE is active for $terminfo
#   # values to be valid.
#   if (( $+terminfo[rmkx] )); then
#     # Disable terminal application mode.
#     echoti rmkx
#   fi
#
#   # Update editor information.
#   zle editor-info
# }
# zle -N zle-line-finish
#
# # Toggles emacs overwrite mode and updates editor information.
# function overwrite-mode {
#   zle .overwrite-mode
#   zle editor-info
# }
# zle -N overwrite-mode
#
# # Enters vi insert mode and updates editor information.
# function vi-insert {
#   zle .vi-insert
#   zle editor-info
# }
# zle -N vi-insert
#
# # Moves to the first non-blank character then enters vi insert mode and updates
# # editor information.
# function vi-insert-bol {
#   zle .vi-insert-bol
#   zle editor-info
# }
# zle -N vi-insert-bol
#
# # Enters vi replace mode and updates editor information.
# function vi-replace  {
#   zle .vi-replace
#   zle editor-info
# }
# zle -N vi-replace
#
# # Expands .... to ../..
# function expand-dot-to-parent-directory-path {
#   if [[ $LBUFFER = *.. ]]; then
#     LBUFFER+='/..'
#   else
#     LBUFFER+='.'
#   fi
# }
# zle -N expand-dot-to-parent-directory-path
#
# # Displays an indicator when completing.
# function expand-or-complete-with-indicator {
#   local indicator
#   zstyle -s ':prezto:module:editor:info:completing' format 'indicator'
#   print -Pn "$indicator"
#   zle expand-or-complete
#   zle redisplay
# }
# zle -N expand-or-complete-with-indicator
#
# # Inserts 'sudo ' at the beginning of the line.
# function prepend-sudo {
#   if [[ "$BUFFER" != su(do|)\ * ]]; then
#     BUFFER="sudo $BUFFER"
#     (( CURSOR += 5 ))
#   fi
# }
# zle -N prepend-sudo

# Reset to default key bindings.
# bindkey -d

#
# Emacs Key Bindings
#

# bindkey -M emacs $key_info[Escape]b emacs-backward-word
# bindkey -M emacs $key_info[Escape]f emacs-forward-word
#
# # Kill to the beginning of the line.
# # for key in "$key_info[Escape]"{K,k}
# bindkey -M emacs $key_info[Escape]k backward-kill-line
#
# # Redo.
# bindkey -M emacs "$key_info[Escape]_" redo
#
# # Search previous character.
# bindkey -M emacs "$key_info[Control]X$key_info[Control]B" vi-find-prev-char
#
# # Match bracket.
# bindkey -M emacs "$key_info[Control]X$key_info[Control]]" vi-match-bracket
#
# # Edit command in an external editor.
# bindkey -M emacs "$key_info[Control]X$key_info[Control]E" edit-command-line
#
# if (( $+widgets[history-incremental-pattern-search-backward] )); then
#   bindkey -M emacs "$key_info[Control]R" history-incremental-pattern-search-backward
#   bindkey -M emacs "$key_info[Control]S" history-incremental-pattern-search-forward
# fi
#
# # bindkey -M emacs "$key_info[Home]" beginning-of-line
# # bindkey -M emacs "$key_info[End]" end-of-line
#
# # bindkey -M emacs "$key_info[Insert]" overwrite-mode
# # bindkey -M emacs "$key_info[Delete]" delete-char
# # bindkey -M emacs "$key_info[Backspace]" backward-delete-char
#
# # bindkey -M emacs "$key_info[Left]" backward-char
# # bindkey -M emacs "$key_info[Right]" forward-char
#
# # Expand history on space.
# bindkey -M emacs ' ' magic-space
#
# # Clear screen.
# # bindkey -M emacs "$key_info[Control]L" clear-screen
#
# # Expand command name to full path.
# # for key in "$key_info[Escape]"{E,e}
# #   bindkey -M "$keymap" "$key" expand-cmd-path
#
# # Duplicate the previous word.
# # for key in "$key_info[Escape]"{M,m}
# #   bindkey -M "$keymap" "$key" copy-prev-shell-word
#
# # Use a more flexible push-line.
# # for key in "$key_info[Control]Q" "$key_info[Escape]"{q,Q}
# #   bindkey -M "$keymap" "$key" push-line-or-edit
#
# # Bind Shift + Tab to go to the previous menu item.
# bindkey -M emacs "$key_info[BackTab]" reverse-menu-complete
#
# # Complete in the middle of word.
# bindkey -M emacs "$key_info[Control]I" expand-or-complete
#
# # Expand .... to ../..
# # if zstyle -t ':prezto:module:editor' dot-expansion; then
# #   bindkey -M "$keymap" "." expand-dot-to-parent-directory-path
# # fi
#
# # Displays an indicator when completing.
# # function expand-or-complete-with-indicator {
# #   local indicator
# #   zstyle -s ':omz:module:editor' completing 'indicator'
# #   print -Pn "$indicator"
# #   zle expand-or-complete
# #   zle redisplay
# # }
# # zle -N expand-or-complete-with-indicator
# #
# # # Display an indicator when completing.
# # bindkey -M emacs "$key_info[Control]I" expand-or-complete-with-indicator
#
# # Insert 'sudo ' at the beginning of the line.
# # bindkey -M emacs "$key_info[Control]X$key_info[Control]S" prepend-sudo
#
# # Do not expand .... to ../.. during incremental search.
# # if zstyle -t ':prezto:module:editor' dot-expansion; then
# #   bindkey -M isearch . self-insert 2> /dev/null
# # fi
#
# #
# # Layout
# #
#
# # Set the key layout.
# # zstyle -s ':prezto:module:editor' key-bindings 'key_bindings'
# # if [[ "$key_bindings" == (emacs|) ]]; then
# #   bindkey -e
# # elif [[ "$key_bindings" == vi ]]; then
# #   bindkey -v
# # else
# #   print "prezto: editor: invalid key bindings: $key_bindings" >&2
# # fi
#
# # unset key{,map,bindings}
