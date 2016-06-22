#!/bin/bash
set -e

case "$1" in
  save)
    PROFILE_DIR="$HOME/.local/share/nvim/profile/profile"
    ;;
  *)
    PROFILE_DIR=/tmp
    ;;
esac

DATE=$(command date +%F-%H%M%S)
PROFILE_OUTPUT_FILE="$PROFILE_DIR"/"$DATE".vim

# --cmd <command>       Execute <command> before loading any vimrc
#    -c <command>       Execute <command> after loading the first file

PROFILE_OUTPUT_FILE="$PROFILE_DIR"/"$DATE".vim \
  command nvim \
  --cmd 'profile start $PROFILE_OUTPUT_FILE' \
  --cmd 'profile file *' \
  --cmd 'profile func *' \
  -c 'profdel file *' \
  -c 'profdel func *' \
  -c 'qa!'

command nvim "$PROFILE_OUTPUT_FILE"
