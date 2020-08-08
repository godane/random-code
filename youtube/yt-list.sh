#!/bin/bash

#youtube-dl -j --flat-playlist https://www.youtube.com/user/chirikun/videos | jq -r '.id' > result.log

url="$1"
if [ "$url" != "" ]; then
youtube-dl -j --flat-playlist "$url" | jq -r '.id' > list.txt
else
	echo "$0 youtube-channel-url"
fi
