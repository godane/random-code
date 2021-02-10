#!/bin/bash

check="yes"
creator="NPR"
baseid="npr-top-of-the-hour-newscast"
for y in 2015; do
for m in $(seq -w 01 12); do
for d in $(seq -w 01 31); do
find $y/$m/$d -name "*.mp3" | while read file; do 

	id="${baseid}-${y}-${m}-${d}"
	date="${y}-${m}-${d}"
	title="NPR Top of the Hour Newscast - ${y}/${m}/${d}"
	basekeywords="NPR; Top of the Hour Newscast;"
	[ -f "$file" ] || continue
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep $(basename $file) $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi
	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="language:english" \
		--metadata="creator:$creator" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}" 
done
done
done
done
