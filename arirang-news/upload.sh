#!/bin/bash


for i in $1; do
	code="RNews"
	pcode="RADR0125"
	file="${i}.m4a"
	id="arirang-audio-aircheck-$code-$pcode-id-$i"
	
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
