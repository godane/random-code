#!/bin/bash

start="1"
end="9999"
for i in $(seq $start $end); do
	dir="$start-to-$end"
	[ -d $dir/$i ] || mkdir -p $dir/$i
	wget -c https://www.subdivx.com/bajar.php?id=${i}&u=9 -P $dir/$i
done
