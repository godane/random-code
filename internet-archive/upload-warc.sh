#!/bin/bash

id="hiddenpalace.org-20180828"
files="wget.log ${id}.cdx ${id}.warc.gz"
for file in $files; do
	title="$id"
	date="2018-08-28"
	desc="This is a incomplete panic grab that happened on 2018-08-28."
	basekeywords="archiveteam; hiddenpalace.org;"
	


	ia upload $id "$file" \
		--metadata="collection:archiveteam-fire" \
		--metadata="mediatype:web" \
		--metadata="language:english" \
		--metadata="date:$date" \
		--metadata="description:$desc" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}" \
		--metadata="year:${date:0:4}"
		#--metadata="runtime:$runtime"
done
