#!/bin/bash

if [ -f list.txt ]; then
	rm list.txt
fi

find -name "Encode_*.mp4" -type f | sort | sed 's|./||g' | while read file; do
	echo "file '$file'" >> list.txt
done

ffmpeg -f concat -i list.txt -vcodec copy -acodec aac -ab 192k -af "volume=20dB" -aspect 4:3 output.mkv
