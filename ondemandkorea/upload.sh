#!/bin/bash


y="2019"
for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
	find -name "*-e${y}${m}${d}*.mp4" -type f | while read file; do
	id="$(basename "$file" .mp4)"
	date="${y}-${m}-${d}"
	basekeywords="JTBC News Room;"
	creator="JTBC"
	[ -f $file ] || continue
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "$(echo "${file}" | sed "s|\[.*||g")")" $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi
	
	
	
	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:movies" \
		--metadata="date:$date" \
		--metadata="creator:$creator" \
		--metadata="subject:${basekeywords}" \
		--metadata="language:korean"
	done
done
