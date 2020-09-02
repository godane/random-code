#!/bin/bash


k="16xxxxx"
id="stitcher-mp3-${k}-ids"
ls ${k}.* | sort | while read file; do
ia upload $id $file \
	--metadata="collection:archiveteam-fire" \
	--metadata="mediatype:web" \
	--metadata="creator:stitcher.com" \
	--metadata="title:stitcher mp3 ${k} ids" \
	--metadata="subject:stitcher.com; archiveteam;"
done
