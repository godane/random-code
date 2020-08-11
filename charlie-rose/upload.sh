#!/bin/bash

check="yes"
y="1996"
for m in 11; do
for d in $(seq 1 31); do
if [ "$(echo $d | wc -c)" == "2" ]; then
	d1="0${d}"
else
	d1="${d}"
fi

date="${y}-${m}-${d1}"
id="Charlie-Rose-${date}"
file="$y/$m/${id}.mp4"
[ -f "$file" ] || continue
vurl="$(cat $y/$m/index.html | grep -B3 " ${d}</i>" | sed 's|.*episodes|https://charlierose.com/video/player|g' | sed 's|" .*||g' | grep ^http | grep -v autoplay | head -1)"
desc="$(curl -s $vurl | grep desc | sed 's|.*content="||g' | sed 's|".*||g' | head -1)"
guests="$(curl -s $vurl | grep '<title>' | sed 's|.*<title>||g' | sed 's|</title>.*||g' | sed 's| — |; |g')"
creator="PBS"
title="Charlie Rose ${date}"
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
		--metadata="mediatype:movies" \
		--metadata="creator:$creator" \
		--metadata="language:english" \
		--metadata="description:$desc" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${guests}"
done
done
