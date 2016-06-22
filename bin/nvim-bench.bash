#!/bin/bash
set -e

DATE=$(command date +%F-%X)
BENCH_DIR="$HOME/.nvim/data/bench"
BENCH_OUTPUT_FILE="$BENCH_DIR"/"$DATE".vim

BENCHVIMRC=$HOME/.config/nvim/test/mattn/benchvimrc-vim/plugin/benchvimrc.vim

# --cmd <command>       Execute <command> before loading any vimrc
#    -c <command>       Execute <command> after loading the first file

case "$1" in
		sort)
			BENCHVIMRC=$HOME/.config/nvim/test/mattn/benchvimrc-vim/plugin/benchvimrc.vim \
				command nvim \
					-c 'source $BENCHVIMRC' \
					-c 'BenchVimrc ~/.config/nvim/init.vim' \
					-c 'bdelete 1' \
					-c 'call DocMappings()' \
					-c '%sort!'
			;;
		save)
			BENCHVIMRC=$HOME/.config/nvim/test/mattn/benchvimrc-vim/plugin/benchvimrc.vim \
				command nvim \
					-c 'source $BENCHVIMRC' \
					-c 'BenchVimrc ~/.config/nvim/init.vim' \
					-c 'bdelete 1' \
					-c 'call DocMappings()' \
					-c "write $BENCH_OUTPUT_FILE"
			;;
		*)
			BENCHVIMRC=$HOME/.config/nvim/test/mattn/benchvimrc-vim/plugin/benchvimrc.vim \
				command nvim \
					-c 'source $BENCHVIMRC' \
					-c 'BenchVimrc ~/.config/nvim/init.vim' \
					-c 'bdelete 1' \
					-c 'call DocMappings()'
			;;
esac
