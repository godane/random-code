#!/bin/bash

check="yes"
for y in 2010; do
for m in $(seq -w 01 12); do
for d in $(seq -w 01 31); do
find m.wsj.net/video/${y}${m}${d} -type f | sort | while read file
id="m.wsj.net-video-${y}-${m}-${d}"

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
title="m.wsj.net video ${y}-${m}-${d}"
creator="Wall Street Journal"

date="${y}-${m}-${d}"

basekeywords="m.wsj.net; wsj.net; Wall Street Journal Video Archive;"

ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:movies" \
		--metadata="creator:$creator" \
		--metadata="date=$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
done
done
done
