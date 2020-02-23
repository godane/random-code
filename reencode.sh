#!/bin/bash

#ffmpeg -i "Batman and Robin CBS WOC 2001-05-18.mkv" -c:v libx264 -b:v 5000k -crf 18 -preset veryfast -c:a copy -vf "scale=720:480" "Batman and Robin CBS WOC 2001-05-18-5000k.mkv"

file="$1"

if [ -f "$file" ]; then
	ffmpeg -i "$file" -c:v libx264 -crf 18 -preset veryfast -c:a copy -vf "scale=720:480" "$(basename "$file" .mkv)-reencode.mkv"
fi

