#!/bin/bash

check="yes"
for i in $1; do
	code="RNews"
	pcode="RADR0125"
	[ -f ${i}.m4a ] || continue
	id="arirang-audio-aircheck-$code-$pcode-id-$i"
	wget -c "http://www.arirang.com/Player/News_Script.asp?code=${code}&AKey=${i}" -O ${i}.html
	find -name "${i}.html" -size 0 -delete
	ls ${i}.* | while read file; do
	if [ "$check" == "yes" ]; then
	url="archive.org/download/$id"
	[ -f "$url" ] || wget -x -c $url
	if [ -f "$url" ]; then
		if [ "$(grep "$(basename "$(echo "${file}" | sed "s|\[.*||g")")" $url)" != "" ]; then
			echo "$file is in $url"
			continue
		fi
	fi
	fi
	basekeywords="Arirang; Radio News; Aircheck;"
	creator="Arirang"
	lang="english"

	ia upload $id $file \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="creator:$creator" \
		--metadata="subject:${basekeywords}" \
		--metadata="language:$lang"
	done
done
