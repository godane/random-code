#!/bin/bash

#13xxxxx to 15xxxxx are done
#http://shoutengine.com/a/a-100695.mp3
k="10"
for i in $(seq -w 0000 0999); do
	url="http://shoutengine.com/a/${k}${i}.mp"
	dir="${k}xxxxx"
	[ -d $dir ] || mkdir -p $dir
	file="$(basename $url)"
	[ -d $file ] ||  wget --content-disposition $url -P $dir
done
