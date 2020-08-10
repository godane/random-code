#!/bin/bash

url="$1"

i="$(basename $url)"
aurl="archive.org/download/niconico-${i}"
[ -f "$aurl" ] || wget -x -c $aurl
if [ -f "$aurl" ]; then
	echo "$aurl exists"
fi

if [ ! -f "$aurl" ]; then
	youtube-dl --external-downloader aria2c --external-downloader-args "-k 2M -x 16 -s 16 -j 16" "$url"
	ls *-$(basename $url).mp4 | while read file; do
		cp "${file}" $HOME/.tubeup/downloads/$(basename $url).mp4
		bash upload.sh $url
	done
fi


