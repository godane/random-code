#!/bin/bash


check="yes"
c="$1"
for i in $(seq ${c}00 ${c}99); do
	id="manualsbase-id-${i}"
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "${i}.pdf")" $url)" != "" ]; then
				echo "${i}.pdf is in $url"
				continue
			fi
		fi
	fi
bash download.sh $i
find -name "${i}.pdf" -empty -delete
ls ${i}.pdf | while read file; do
	title1="$(curl -s http://www.manualsbase.com/manual/${i}/1/1/1/ | grep -a title | sed 's|.*<title>||g' | sed 's| - ManualsBase.com.*||g' | head -1)"
	title="$title1"

	basekeywords="manualsbase; manuals;"

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
done
