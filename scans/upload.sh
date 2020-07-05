#!/bin/bash

lang="english"
ls *.cbz | while read file; do
		id="$(basename "$file" .cbz)"

		title="$id"
		[ -f "$file" ] || continue
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
		

	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="language:$lang" \
		--metadata="title:$title"
done
