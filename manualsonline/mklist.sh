#!/bin/bash

p="25"
bpage="bpage${p}.txt"

if [ ! -f $bpage ]; then
	curl -s http://www.manualsonline.com/brands/?p=$p | grep '<h5>' | sed 's|.*brands/||g' | sed 's|".*||g' | grep ^[a-z] > $bpage
else
	echo "$bpage exists"
fi
