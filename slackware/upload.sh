#!/bin/bash

lang="english"
ls *.tar | while read file; do
		ver="$(basename "$file" .tar)"
		id="rsync-${ver}-20200814"
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
		desc="Here is ${ver} that was rsync from here: rsync://slackware.uk/slackware/. This is so all software updates after the official iso are backed up. These versions of slackware are no supported anymore so shouldn't be seeing any updates."

	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:software" \
		--metadata="description:$desc" \
		--metadata="language:$lang" \
		--metadata="title:$title"
done
