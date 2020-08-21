#!/bin/sh

creator="KBS World News"
show="Korea 24"
show1="korea-24"
idname="kbs-world-news-podcast-${show1}"
lang="english"

for y in $(seq 2017 2020); do
	for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
	file="ek24_${y:2:4}${m}${d}.mp3"
	[ -f $file ] || break
	date="${y}-${m}-${d}"
	title="${show} ${date}"
	id="${idname}-${date}"
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
	basekeywords="${creator}; ${show};"

	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="creator:$creator" \
		--metadata="language:$lang" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}" 
done
done
done
