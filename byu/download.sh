#!/bin/bash

for y in 2020; do

	for m in $(seq -w 01 12); do
		for d in $(seq -w 01 31); do
			url="http://byubmp3.byu.edu/byuradio/brtop/brtop-${m}${y:2:4}-${d}.mp3"
			file="$(basename $url)"
			[ -d $y/$m ] || mkdir -p $y/$m
			[ -f $y/$m/$file ] || wget -c $url -O $y/$m/$file
		done
	done
done
