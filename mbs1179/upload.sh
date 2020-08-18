#!/bin/bash

name="podfit"
for y in $(seq 2008 2019); do
	for m in $(seq -w 01 12); do
		for d in $(seq -w 01 31); do
			date="${y}-${m}-${d}"
			id="mbs-radio-${name}-podcast-${date}"
			title="MBS Radio ${name} Podcast ${date}"
			keywords="MBS Radio; ${name}; mbs1179;"
			file="${y}${m}${d}_00.mp3"
			ia upload $id $file \
				--metadata="collection:godaneinbox" \
				--metadata="mediatype:audio" \
				--metadata="title:$title" \
				--metadata="subject:${keywords}" \
				--metadata="language:Japanese"
		done
	done
done
