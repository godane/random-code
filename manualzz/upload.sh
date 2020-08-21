#!/bin/bash


check="yes"
c="$1"
for i in $c; do
	id="manualzz-id-${i}"
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
#bash download.sh $i
find -name "${i}.pdf" -empty -delete
ls ${i}.pdf | while read file; do
	t="10"
	sleep $t
	echo "sleep $t"
	title1="$(curl -s https://manualzz.com/doc/$i/ | grep og:title | sed 's|.*content="||g' | sed 's| \| .*||g')"
	title="$title1"

	basekeywords="manualzz; manuals;"

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
done
