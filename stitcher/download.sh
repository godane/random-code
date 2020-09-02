#!/bin/bash

#13xxxxx to 15xxxxx are done
k="12"
for i in $(seq -w 00000 99999); do
	url="http://cloudfront.stitcher.com/${k}${i}.mp3"
	dir="${k}xxxxx"
	[ -d $dir ] || mkdir -p $dir
	file="$(basename $url)"
	[ -d $file ] ||  wget -c $url -P $dir
done
