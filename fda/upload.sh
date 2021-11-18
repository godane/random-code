#!/bin/bash

website="fda.gov"
ls *.zip | while read file; do

	
	id="fda.gov-media-$(basename $file .zip)"
	desc="This are the fda.gov/media/number/download files for area $(basename "$file" .zip)."
	
	basekeywords="$website; archiveteam; panic grab;"

	ia upload $id "$file" \
		--metadata="collection:archiveteam-fire" \
		--metadata="mediatype:web" \
		--metadata="description:$desc" \
		--metadata="subject:${basekeywords}"
done
