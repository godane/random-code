#!/bin/bash

#for i in $(find -type d | sort); do
if [ -d "$1" ]; then
for i in $1; do
cd $i
	for a in $(ls); do
		wget -c https://archives.kpfa.org/data/${a}
	done
cd ../
done
fi
