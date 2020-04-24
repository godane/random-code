#!/bin/bash


show="steve-and-ted-in-the-morning"
for y in 2016; do
	for m in 06; do
		for d in 02; do
			for offset in 8670; do
				for mp3url in $(curl -s "https://omny.fm/shows/$show/api/clips?offset=${offset}&in_playlist=podcast" | sed 's|,|\n|g' | grep -B3 ${y}-${m}-${d}  | sed 's|.*Url":"|http://omny.fm|g' | sed 's|"||g' | grep mp3); do
					file="$(basename $mp3url)"
					dir="$y/$m/$d"
					[ -d $dir ] || mkdir -p $dir
					[ -f $dir/$file ] || wget -c $mp3url -O $dir/$file
				done
			done
		done
	done
done
