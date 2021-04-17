#!/bin/bash


show="sn"
show1="security-now"
type="Audio"
ls ${show}*.mp3 | while read file; do
id="twit-tv-${show1}-${type,,}-only-archive"

[ -f $file ] || continue
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
basekeywords="TWiT; Podcast; Computers; Tech; Audio; Leo Laporte; Steve Gibson;"
title="TWiT.tv Security Now ${type} Only Archive"
mediatype="${type,,}"
creator="TWiT"
	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:$mediatype" \
		--metadata="language:english" \
		--metadata="creator:$creator" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}" 
done
