generate() {
  tmpfile=$(mktemp /tmp/terminfo.XXXXXXX)
  /usr/bin/infocmp "$1" | sed -e 's/\(ritm\|sitm\|rmso\|smso\)=[^,]\+, *//g' > $tmpfile
  echo '\tritm=\E[23m, rmso=\E[27m, sitm=\E[3m, smso=\E[7m, ms@,' >> $tmpfile
  /usr/bin/tic -x $tmpfile
  rm -f $tmpfile
}

generate 'xterm-256color'
generate 'screen-256color'
