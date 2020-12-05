#!/bin/sh



check="yes"
year="2020"
bucket="x-amz-auto-make-bucket:1"
for m in 11; do
for i in $(seq -w 14 31); do #$(seq -w 19 30); do #$(seq 3 31); do #$(seq -w 26 28); do
station="chmlam"
filelist="$(find $station -name "${y}.${m}.${d}-*" -type f -size +1M | sort)"
for file in $filelist; do
	id="global-news-radio-${station}-${year}-${m}-${i}"
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep $(basename $file) $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi
	[ -f "$file" ] || continue
	basekeywords="Global News; ${station}"
	date="$year-$m-$i"
	title="Global News Radio ${station} - ${year}/${m}/$i"
	creator="Global News"
	ia upload $id "$file" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="creator:$creator" \
		--metadata="language:english" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
		

done
done
done
