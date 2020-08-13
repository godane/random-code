#!/bin/bash

y="2016"
for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
		# use megaphone rss feed for mp3s: https://feeds.megaphone.fm/fast-money
		url="$(cat fast-money | grep -A15 ${m}/${d}/${y:2:4} | sed 's|.*mp3/||g' | sed 's|".*||g' | grep ^traf)"
		file="FastMoney-${m}${d}${y:2:4}.mp3"
		[ -d $y/$m ] || mkdir -p $y/$m
		[ -f $y/$m/$file ] || wget -c $url -O $y/$m/$file
	done
done
