#!/bin/bash

y="1996"
for m in 11; do
for d in $(seq 1 31); do
if [ "$(echo $d | wc -c)" == "2" ]; then
	d1="0${d}"
else
	d1="${d}"
fi

vurl="$(cat $y/$m/index.html | grep -B3 " ${d}</i>" | sed 's|.*episodes|https://charlierose.com/video/player|g' | sed 's|" .*||g' | grep ^http | grep -v autoplay | head -1)"
date="${y}-${m}-${d1}"
desc="$(curl -s $vurl | grep desc | sed 's|.*content="||g' | sed 's|".*||g' | head -1)"
file="$y/$m/Charlie-Rose-${y}-${m}-${d1}.mp4"
guests="$(curl -s $vurl | grep '<title>' | sed 's|.*<title>||g' | sed 's|</title>.*||g' | sed 's| — |; |g')"
creator="PBS"
title="Charlie Rose ${date}"

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
