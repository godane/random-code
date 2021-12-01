#!/bin/bash

website="subdivx.com"
ls *.tar | while read file; do

	
	id="subdivx-sub9-$(basename $file .tar)"
	desc="This are the http://www.subdivx.com/sub9/download files for area $(basename "$file" .tar)."
	
	basekeywords="$website; archiveteam; panic grab;"

	ia upload $id "$file" \
		--metadata="collection:archiveteam-fire" \
		--metadata="mediatype:web" \
		--metadata="description:$desc" \
		--metadata="subject:${basekeywords}"
done
