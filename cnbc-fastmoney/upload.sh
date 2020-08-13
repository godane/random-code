#!/bin/bash

y="2016"
for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
		title="CNBC FastMoney Podcast ${y}-${m}-${d}"
		basekeywords="CNBC FastMoney Podcast;"
		id="cnbce-fastmoney-podcast-${y}-${m}-${d}"
		file="$y/$m/FastMoney-${m}${d}${y:2:4}.mp3"
	
		ia upload $id "$file" \
			--metadata="collection:godaneinbox" \
			--metadata="mediatype:audio" \
			--metadata="title:$title" \
			--metadata="subject:${basekeywords}"
	done
done
