#!/bin/sh

check="yes"
y="2018"
for m in $(seq -w 01 12); do
for d in $(seq -w 01 31); do
	file="pam-${y}-${m}-${d}.mp3"
	id="abc-am-full-${y}-${m}-${d}"
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
	basekeywords="ABC; ABC AM; Australian Broadcasting Corporation;"
	date="${y}-${m}-${d}"
	title="ABC AM Full - ${m}/${d}/${y}"
	creator="ABC"
	ia upload $id "$file" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="creator:$creator" \
		--metadata="language:english" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
		

done
done
