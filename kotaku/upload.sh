#!/bin/bash

y="2016"
for m in 12; do
for d in $(seq -w 01 31); do
website="kotaku.com"
subject="sitemap-${y}-${m}-${d}"
date="20200908"
warcfile="$website-$subject-${date}"
dir="$y/$m/$d"
for file in $dir/wget.log $dir/index.txt $dir/${warcfile}.warc.gz $dir/${warcfile}.cdx; do

	id="$warcfile"
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "$file")" $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi
	desc="This is a panic download of $website $subject as of $(date -d $date +%Y-%m-%d)."
	basekeywords="$website; archiveteam;"

	ia upload $id "$file" \
		--metadata="collection:archiveteam-fire" \
		--metadata="mediatype:web" \
		--metadata="description:$desc" \
		--metadata="subject:${basekeywords}"
done
done
done
