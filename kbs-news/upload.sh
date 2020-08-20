#!/bin/bash

check="yes"
y="1987"
for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
		ls $y/$m/$d/*.mp4 | while read file; do
		name="news9"
		id="kbs-news-video-${name}-${y}-${m}-${d}-1500k"
		title="KBS News Video ${name} ${y}-${m}-${d}"
		basekeywords="KBS News Video; ${name};"
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

		lang="korean"
		ia upload $id "$file" \
			--metadata="collection:godaneinbox" \
			--metadata="mediatype:movies" \
			--metadata="title:$title" \
			--metadata="creator:KBS" \
			--metadata="language:$lang" \
			--metadata="subject:${basekeywords}"
	done
done
