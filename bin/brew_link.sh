#!/bin/bash

hander()
{
  exit 1
}
trap hander SIGINT

file=brew_link.list
touch $file

unlink=()
# force=()

for i in $(brew list)
do
  cmd=`brew link $i --dry-run`
  if [[ "$cmd" =~ ^Would* ]]; then
    unlink+=($i)
  fi
  echo "$i\n" >> $file
  echo $cmd >> $file
done

echo "Unlinked packages: ${unlink[@]}"
# echo "keg-only unlinked packages: ${force[@]}"
