#!/bin/bash

check="yes"
radio="radio3"
name"Hong Kong Today"
creator="RTHK"
for y in 2017; do
for m in $(seq -w 03 12); do
for d in $(seq -w 01 31); do
file="${y}${m}${d}.mp3"
[ -f $file ] || continue
title="${creator} ${radio} ${name} - ${y}/${m}/${d}"
baskeywords="${creator}; ${radio}; ${name};"
id="${creator,,}-${radio}-$(echo ${name,,} | sed 's| ||g')-${y}-${m}-${d}"

	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "${file}")" $url)" != "" ]; then
				echo "${file} is in $url"
				continue
			fi
		fi
	fi

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="creator:$creator" \
		--metadata="title:$title" \
		--metadata="language:$lang" \
		--metadata="subject:${basekeywords}"
done
done
done
