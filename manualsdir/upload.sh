#!/bin/bash


check="yes"
c="$1"
ext="cbz"
for i in $(seq ${c}00 ${c}99); do
	id="manualsdir-id-${i}"
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
find -name "${i}.${ext}" -empty -delete
ls ${i}.pdf | while read file; do
	title1="$(curl -L -s https://www.manualsdir.com/manuals/$id/a.html | grep title | grep 'h1 class=' | sed 's|.*">||g' | sed 's|<.*||g')"
	title2="$(curl -L -s https://www.manualsdir.com/manuals/$id/a.html | grep title | grep 'h2 class=' | sed 's|.*">||g' | sed 's|<.*||g')"
	title="$title1"

	basekeywords="manualsdir; manuals; $title2;"

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
done
