#!/bin/bash


y="2019"
for m in $(seq -w 05 12); do
	for d in $(seq -w 01 31); do
		name="jtbc-news-room-e${y}${m}${d}-1"
		m3u8url="$(curl -s  https://www.ondemandkorea.com/${name}.html  | grep m3u8 | sed 's|.*http|http|g' | sed 's|m3u8.*|m3u8|g')"

		[ -f ${name}.mp4 ] ||youtube-dl $m3u8url -o ${name}.mp4
	done
done



