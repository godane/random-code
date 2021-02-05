#!/bin/bash


check="yes"
ext="pdf"
c="$1"
for i in $c; do
	id="manuallib-id-${i}"
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "${i}.${ext}")" $url)" != "" ]; then
				echo "${i}.${ext} is in $url"
				continue
			fi
		fi
	fi
bash download.sh $i
find -maxdepth 1 -type f -empty -delete
ls ${i}.${ext} | while read file; do
	title1="$(cat ${i}.html | grep '<h1>' | sed 's|<h1>||g' | sed 's|</h1>||g')"
	title="${title1}"

	keywords="$(cat ${i}.html | grep -A1 Brand | tail -1 | sed 's|.*">||g' | sed 's|</a>||g')"
	basekeywords="manuallib; manuals; ${keywords}"

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
done
