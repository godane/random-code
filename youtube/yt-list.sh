#!/bin/bash

#youtube-dl -j --flat-playlist https://www.youtube.com/user/chirikun/videos | jq -r '.id' > result.log

url="$1"
list="$2"
if [ "$list" == "" ]; then
	list="list.txt"
else
	list="$2"
fi

if [ "$url" != "" ]; then
youtube-dl -j --flat-playlist "$url" | jq -r '.id' > "$list"
else
	echo "$0 youtube-channel-url"
fi
