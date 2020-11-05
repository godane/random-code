#!/bin/bash


check="yes"
find -name "${i}.pdf" -empty -delete
ls *.pdf | while read file; do
	id="lost_manuals_$(basename "$file" .pdf)"
	
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
	basekeywords="lost-manuals; manuals;"

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="subject:${basekeywords}"
done
