#!/bin/bash

#youtube-dl -j --flat-playlist https://www.youtube.com/user/chirikun/videos | jq -r '.id' > result.log

check="yes"
if [ "$1" == "" ]; then
for i in $(tac list.txt); do
	if [ "$check" == "yes" ]; then
		i1="$(echo $i | grep \- | sed 's|^--||g' | sed 's|^-||g'| sed 's|--|-|g')"
		if [ "$i1" == "" ]; then
		    url="archive.org/download/youtube-${i}"
		else
		    url="archive.org/download/youtube-${i1}"
		fi
		echo $url
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			continue
		fi
	fi
tubeup youtube.com/watch?v=$i --metadata="collection:godaneinbox"
done
else
tubeup $1 --metadata="collection:godaneinbox"
fi
