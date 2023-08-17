#!/bin/bash


nfile=$(basename $1 | sed 's/.bed//g')
echo $nfile
output=$nfile"_stat.out"
rm $output
touch $output

totlen=$(cat $1 | awk '{ totlen+=($3-$2) } END {print totlen}')
x=$(cat $1 | awk -v tl=$totlen '{ sum+=(($3-$2)*$4) } END {print sum/tl}')
x10=$(cat $1 | awk -v tl=$totlen '$4 > 9 { len10+=($3-$2) } END {print len10/tl}')
x20=$(cat $1 | awk -v tl=$totlen '$4 > 19 { len20+=($3-$2) } END {print len20/tl}')

echo $1 $x $x10 $x20 >> $output
