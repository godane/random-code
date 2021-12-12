#!/bin/bash


k="100xxx"
id="shoutengine-mp3-${k}-ids"
ls ${k}.* | sort | while read file; do
ia upload $id $file \
	--metadata="collection:archiveteam-fire" \
	--metadata="mediatype:web" \
	--metadata="creator:shoutengine.com" \
	--metadata="title:shoutengine mp3 ${k} ids" \
	--metadata="subject:shoutengine.com; archiveteam;"
done
