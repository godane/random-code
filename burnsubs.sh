#!/bin/bash

file="$1"

ext="mp4"
ffmpeg -i "$file" -c:v libx264 -crf 18 -preset veryfast -c:a copy -vf subtitles="$(basename "$file" .${ext}).srt" "$(basename "$file" .${ext})-burnsubs.${ext}"
