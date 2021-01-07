#!/bin/bash


check="yes"

y="1965"
for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
	id="cycle-news-${y}-${m}-${d}"
	file="${id}.pdf"
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "${file}")" $url)" != "" ]; then
				echo "${file} is in $url"
				continue
			fi
		fi
	fi

	title="Cycle News ${y}-${m}-${d}"
	basekeywords="Cycle News;"

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
done
