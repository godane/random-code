#!/bin/bash

[ ! -f list.txt ] || rm list.txt
base="$(basename $1)"
if [ ! -f "$base.mp4" ]; then
url1="http://archive.org/download/${base}/${base}.mp4"
diff="185"
endt1="$(curl -L -s http://archive.org/details/${base} | sed 's|","|\n|g' | grep t=  | sed 's|.*/||g' | grep ignore | sed 's|&ignore.*||g' | tail -1)"
echo $endt1
endt="$(echo "$endt1 + $diff" | bc)"
for i in $(seq 0 $diff $endt); do #$(curl -s $1 | sed 's|","|\n|g' | grep mp4 | sed 's|.*\["||g' | sed 's|".*||g' | grep ^http | sed 's|0/|1/|g' ); do
	#file="$(echo $i | sed 's|.*/||g' | sed 's|&.*||g').mp4"
	end="$(echo "${i} + $diff" | bc)"
	#if [ "$i" != "0" ]; then
	#	i="$(echo "${i}" | bc)"
	#fi
	url="${url1}?exact=1&start=${i}&end=${end}&ignore=x.mp4"
	[ -d $base ] || mkdir -p $base
	[ -f $base/$end.mp4 ] || wget -c $url -O $base/$end.mp4
	find $base -size 0 -delete
	#[ -f list.txt ] || rm list.txt
	if [ "$(find $base/$end.mp4 -size +200k -type f)" != "" ]; then 
		echo "file '$base/$end.mp4'" >> list.txt
	fi
done
fi
#find $base -name "[0-9][0-9][0-9].mp4"  | sort | while read f; do
#	echo "file '$f'" >> list.txt
#done
#find $base -name "[0-9][0-9][0-9][0-9].mp4"  | sort | while read f; do
#	echo "file '$f'" >> list.txt
#done


	[ -f ${base}.mp4 ] || ffmpeg -f concat -i list.txt -c copy ${base}.mp4
