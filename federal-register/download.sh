#!/bin/bash

#y="1988"

#for y in $(seq 1970 1979); do
for y in 1992; do #$(seq 1956 1960); do #$(seq 1942 1945); do
for m in 06; do #$(seq -w 10 12); do
	for d in $(seq -w 01 31); do
		basefile="FR-${y}-${m}-${d}"
		file="$basefile.pdf"
		#url="https://www.gpo.gov/fdsys/pkg/$basefile/pdf/$file"
		url="https://www.govinfo.gov/content/pkg/$basefile/pdf/$file"
		[ -d $y ] || mkdir -p $y
		#[ -f $y/$file ] || wget -c $url -O $y/$file
		wget -c $url -O $y/$file
	done
done
done
