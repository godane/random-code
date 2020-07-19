#!/bin/bash

dir="$1"

if [ -d "$dir" ]; then

mktorrent -a http://bt1.archive.org:6969/announce \
	-a http://bt2.archive.org:6969/announce \
	-a udp://tracker.publicbt.com:80/announce \
	-a udp://tracker.openbittorrent.com:80 \
	-a udp://tracker.ccc.de:80 \
	-a udp://tracker.istole.it:80 \
	-a http://tracker.publicbt.com:80/announce \
	-a http://tracker.openbittorrent.com/announce \
	-o "${dir}.torrent" "${dir}"
fi
