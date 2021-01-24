#!/bin/bash

for y in 2012; do
for m in $(seq -w 03 12); do
for d in $(seq -w 01 31); do
	file="le_${y}${m}${d}_high.mp3"
	url="https://s3.amazonaws.com/media.townhallstore.com/le/elder-nox/audio/$file"
	[ -d $y/$m/$d ] || mkdir -p $y/$m/$d
	wget -c $url -O $y/$m/$d/$file
done
done
done
