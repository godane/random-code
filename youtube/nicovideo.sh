#!/bin/bash

url="$1"
youtube-dl --external-downloader aria2c --external-downloader-args "-k 2M -x 16 -s 16 -j 16" "$url"

filename="$(basename $url).mp4"
cp *-${filename}.mp4 $HOME/.tubeup/downloads/${filename}.mp4

bash upload.sh $url
