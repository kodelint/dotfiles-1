#!/bin/bash
set -ex

DATE=$(command date +%F-%H%M%S)
STARTUPTIME_PATH=~/.local/share/nvim/profile/startuptime

# --cmd <command>       Execute <command> before loading any vimrc
# -c <command>          Execute <command> after loading the first file
# --startuptime <file>  Write startup timing messages to <file>
command nvim --startuptime "$STARTUPTIME_PATH"/"$DATE".vim -c 'quit!' $1
command nvim "$STARTUPTIME_PATH"/"$DATE".vim
