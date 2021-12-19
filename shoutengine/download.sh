#!/bin/bash

#13xxxxx to 15xxxxx are done
#http://shoutengine.com/a/a-100695.mp3
k="100"
start="${k}000"
end="${k}999"
for i in $(seq -w 000 999); do
	url="http://shoutengine.com/a/a-${i}.mp3"
	dir="${k}xxx/${i}"
	[ -d $dir ] || mkdir -p $dir
	file="$(basename $url)"
	if [ "$(find $dir -name "*.mp3" -type f)" == "" ]; then
		wget --content-disposition $url -P $dir
	fi
done
