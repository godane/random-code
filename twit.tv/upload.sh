#!/bin/bash

check="yes"
show="sn"
type="Audio"

if [ "$show" == "sn" ]; then
	show1="security-now"
	show2="Security Now"
	hosts="Leo Laporte; Steve Gibson;"
elif [ "$show" == "ttg" ]; then
	show1="the-tech-guy"
	show2="The Tech Guy"
	hosts="Leo Laporte"
elif [ "$show" == "ww" ]; then
	show1="windows-weekly"
	show2="Windows Weekly"
	hosts="Leo Laporte; Mary Jo Foley; Paul Thurrott"
elif [ "$show" == "tnt" ]; then
	show1="tech-news-today"
	show2="Tech News Today"
	hosts="Mike Elgan; Jason Howell; Tom Merritt; Becky Worley;"
elif [ "$show" == "twit" ]; then
	show1="this-week-in-tech"
	show2="This Week In Tech"
	hosts="Leo Laporte;"
fi

id="twit-tv-${show1}-${type,,}-only-archive"
ls ${show}*.mp3 | while read file; do

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
basekeywords="TWiT; Podcast; Computers; Tech; Audio; ${hosts};"
title="TWiT.tv ${show2} ${type} Only Archive"
mediatype="${type,,}"
creator="TWiT"
	ia upload $id "$file" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:$mediatype" \
		--metadata="language:english" \
		--metadata="creator:$creator" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}" 
done
