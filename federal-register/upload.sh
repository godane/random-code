#!/bin/bash


#y="1940"
check="yes"
for y in 1992; do #$(seq 1942 1945); do
for m in 05; do #$(seq -w 10 12); do
	for d in $(seq -w 01 31); do
name="Federal Register"
date="$y-$m-$d"

id="federal-register-$date"
title="${name} $date"
file="$y/FR-${date}.pdf"
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
basekeywords="${name};"
lang="english"
media="texts"


	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:$media" \
		--metadata="language:$lang" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}" \
		--metadata="year:${date:0:4}"
done
done
done

