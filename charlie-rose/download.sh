#!/bin/bash

#y="1993"
#m="01"

#y="1999"
y="1996"
#y="2004"
#m="07"
for m in $(seq -w 11 12); do
[ -d $y/$m ] || mkdir -p $y/$m
[ -f  $y/$m/index.html ] || wget --no-check-certificate -c  "https://charlierose.com/episodes?date[year]=${y}&date[month]=${m}" -O $y/$m/index.html

bit="-f 762"
#bit="-f 1962"

for d in $(seq 1 31); do
if [ "$(echo $d | wc -c)" == "2" ]; then
	d1="0${d}"
else
	d1="${d}"
fi

vurl="$(cat $y/$m/index.html | grep -B3 " ${d}</i>" | sed 's|.*episodes|https://charlierose.com/video/player|g' | sed 's|" .*||g' | grep ^http | grep -v autoplay | head -1)"
if [ "$vurl" != "" ]; then
	file="Charlie-Rose-${y}-${m}-${d1}.mp4"
	[ -f $y/$m/$file ] || youtube-dl --no-check-certificate --add-metadata --embed-subs --all-subs $bit -o $y/$m/$file $vurl
	#youtube-dl --no-check-certificate --add-metadata --embed-subs --all-subs $bit -o $y/$m/$file $vurl

fi
#turl="$(cat $y/$m/index.html | grep -B3 " ${d}</i>" | sed 's|.*episodes|https://charlierose.com/video/transcripts|g' | sed 's|" .*||g' | grep ^http | grep -v autoplay)"
#if [ "$turl" != "" ]; then
#	tfile="Charlie-Rose-${y}-${m}-${d1}.transcript.html"
#	echo "Downloading $tfile"
#	[ -f $y/$m/$tfile ] || wget -c $turl -O $y/$m/$tfile
#fi

done
done
