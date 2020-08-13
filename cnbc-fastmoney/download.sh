#!/bin/bash

y="2016"
for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
		url="http://podcast.cnbc.com/FastMoney-${m}${d}${y:2:4}.mp3"
		file="$(basename $url)"
		[ -d $y/$m ] || mkdir -p $y/$m
		[ -f $y/$m/$file ] || wget -c $url -O $y/$m/$file
	done
done
