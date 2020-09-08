#!/bin/bash

website="kotaku.com"
subject="sitemap-${y}-${m}-${i}"
date="20200908"
warcfile="$website-$subject-${date}"
dir="$y/$m/$d"
for file in $dir/wget.log $dir/index.txt $dir/${warcfile}.warc.gz $dir/${warcfile}.cdx; do

	id="$warcfile"
	desc="This is a panic download of $website $subject as of $(date -d $date +%Y-%m-%d)."
	basekeywords="$website; archiveteam;"

	ia upload $id "$file" \
		--metadata="collection:archiveteam-fire" \
		--metadata="mediatype:web" \
		--metadata="description:$desc" \
		--metadata="subject:${basekeywords}"
done
