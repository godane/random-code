#!/bin/bash

check="yes"
for y in $(seq 2016 2019); do
for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
		title="CNBC FastMoney Podcast ${y}-${m}-${d}"
		basekeywords="CNBC FastMoney Podcast;"
		id="cnbc-fastmoney-podcast-${y}-${m}-${d}"
		creator="CNBC"
		lang="english"
		date="${y}-${m}-${d}"
		file="$y/$m/FastMoney-${m}${d}${y:2:4}.mp3"
		if [ "$check" == "yes" ]; then
			url="archive.org/download/$id"
			[ -f "$url" ] || wget -x -c $url
			if [ -f "$url" ]; then
				if [ "$(grep "$(basename "$file")" $url)" != "" ]; then
					echo "$file is in $url"
					continue
				fi
			fi
		fi
		[ -f $file ] || continue
		
		ia upload $id "$file" \
			--metadata="collection:godaneinbox" \
			--metadata="mediatype:audio" \
			--metadata="title:$title" \
			--metadata="date:$date" \
			--metadata="creator:$creator" \
			--metadata="language:$lang" \
			--metadata="subject:${basekeywords}"
	done
done
done
