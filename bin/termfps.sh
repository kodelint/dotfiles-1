#!/bin/bash
# Copyright (c) 2010, 2013 Yu-Jie Lin
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Usage: termfps.sh [FRAMES] [COLUMNS] [LINES]

FRAMES=${1:-100}
COLUMNS=${2:-$(tput cols)}
LINES=${3:-$(tput lines)}
CHARS=$((COLUMNS * LINES * FRAMES))

printf -v dummy_line   "%${COLUMNS}s"     ''
printf -v dummy_line_n "%${COLUMNS}s\n"   ''
printf -v dummy_frame  "%$((LINES - 1))s" ''

for ((ch = 0; ch < 10; ch++)); do
  line_str=${dummy_line// /$ch}
  line_n_str=${dummy_line_n// /$ch}
  frame_str="${dummy_frame// /$line_n_str}$line_str"
  frame_str_r="frame_str$ch"

  eval "$frame_str_r=\"$frame_str\""
done

t_start=$(date +%s.%N)
# t_start=`python -c'import time; print repr(time.time())'`
for ((i = 0; i < FRAMES; i++)); do
  for ((ch = 0; ch < 10; ch++)); do
    frame_str="frame_str$ch"
    echo -ne "\033[H${!frame_str}"
  done
done
t_end=$(date +%s.%N)
# t_end=`python -c'import time; print repr(time.time())'`

echo
echo "For ${COLUMNS}x${LINES} $FRAMES frames."
printf "Elapsed time : %'9.3f\n" "$(bc <<< "scale=3;           ($t_end - $t_start) / 1")"
printf "Frames/second: %'9.3f\n" "$(bc <<< "scale=3; $FRAMES / ($t_end - $t_start)")"
printf "Chars /second: %'9d\n"   "$(bc <<< "scale=0; $CHARS  / ($t_end - $t_start)")"

# Applet built-in Terminal
# For 80x25 1000 frames.
# Elapsed time :     2.734
# Frames/second:   365.714
# Chars /second:   731,428

# pure iTerm
# For 80x25 1000 frames.
# Elapsed time :     3.240
# Frames/second:   308.606
# Chars /second:   617,213

# Neovim terminal
# Elapsed time :     3.799
# Frames/second:   263.219
# Chars /second:   526,438

# Tmux 2016-04-13
# For 80x25 1000 frames.
# Elapsed time :     6.093
# Frames/second:   164.100
# Chars /second:   328,201

# When?
# Elapsed time :     9.848
# Frames/second:    10.153
# Chars /second:   169,765

# http://blog.yjl.im/2010/12/testing-fps-of-terminal.html
# terminal				elapsed-time	fps
# urxvtc1					08.882				112.580
# urxvtc					09.126				109.574
# urxvt						09.140				109.401
# urxvtc + tmux2	10.568				094.616
# urxvtc + tmux		10.546				094.813
# urxvtc + tmux3	11.214				089.173
# xterm						16.487				060.653
# lxterminal			39.211				025.502
# vt1							54.984				018.187
