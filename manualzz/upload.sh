#!/bin/bash


check="yes"
c="$1"
ip="$2"
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
	#curl -s https://manualzz.com/models/802 | grep doc/ | sed 's|.*href="/doc/||g' | sed 's|/.*||g' | sort | uniq
bash download.sh $i $ip
#killall -9 firefox
find -maxdepth 1 -empty -delete
ls ${i}.pdf | while read file; do
	#t="10"
	#sleep $t
	#echo "sleep $t"
	title1="$(cat ${i}.html | grep og:title | sed 's|.*content="||g' | sed 's| \| .*||g' | sed 's|.*<title>||g')"
	title="$title1"
	#keywords="$(cat ${i}.html | grep 'name="keywords' | sed 's|.*content="||g' | sed 's|,|;|g' | sed 's|".*||g')"
	basekeywords="manualzz; manuals;"
	echo "$title"

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
done
