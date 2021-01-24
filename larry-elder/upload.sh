#!/bin/bash

for y in 2012; do
for m in $(seq -w 03 12); do
for d in $(seq -w 01 31); do
find $y/$m/$d -type f | while read file; do

name="The Larry Elder Show"
title="${name} - ${m}/${d}/${y}"
date="${y}-${m}-${d}"
creator="Larry Elder"
basekeywords="Larry Elder; ${name};"	
[ -f $file ] || continue
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
	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="language:english" \
		--metadata="creator=$creator"
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
done
done
done
