#!/bin/bash

start="1"
end="9999"
for i in $(seq $start $end); do
	dir="$start-to-$end"
	for a in zip rar; do
		[ -d $dir/$i ] || mkdir -p $dir/$i
		wget -c -U firefox "https://www.subdivx.com/sub9/${i}.${a}" -P $dir/$i
	done
done
