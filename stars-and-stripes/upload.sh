#!/bin/bash

y="2017"
for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
		iss="GSS_GSS"
		id="stars-and-stripes-${iss}-${y}-${m}-${d}"
		file="${iss}_${d}${m}${y:2:4}.pdf"
		title="Stars and Stripes Main Edition ${y}-${m}-${d}"
		basekeywords="Stars and Stripes;"
	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="language:english" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
	done
done
