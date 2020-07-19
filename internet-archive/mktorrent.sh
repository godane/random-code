#!/bin/bash

dir="$1"

if [ -d "$dir" ]; then

mktorrent -a udp://tracker.publicbt.com:80/announce \
	-a udp://tracker.openbittorrent.com:80 \
	-a udp://tracker.ccc.de:80 \
	-a udp://tracker.istole.it:80 \
	-a http://tracker.publicbt.com:80/announce \
	-a http://tracker.openbittorrent.com/announce \
	-o "${dir}.torrent" "${dir}"
fi
