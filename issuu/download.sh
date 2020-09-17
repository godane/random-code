#!/bin/bash

#y="2011"
#m="09"
#m1="$m"
# code to grab 
# cat index.html | grep 'Technique Magazine' | sed 's|.*href="||g' | sed 's|".*||g' | grep ^http | sort | uniq | grep -v stacks > index.txt
#for i in $(seq -w 02 12); do
	#url="issuu.com/phillycp/docs/issuu_${m}_${i}_${y:2:4}"
	#url="issuu.com/phillycp/docs/cp_${y}-${m}-${i}"
	#url="$1"
	user="switchplayer"
for dir in $(cat index.txt); do
	baseurl="https://issuu.com/$user/docs/$dir"
	#dir="$url"
	echo "Downloading $baseurl"
	if [ ! -f $dir.cbz ]; then
	bash issuu-downloader $baseurl 999
	#[ "$(echo "$i" | wc -c)" == "2" ] && i="0${i}"
	#[ "$(echo "$m" | wc -c)" == "2" ] && m1="0${m}"
	#[ -d issud ] && mv -f issud ${y}-${m1}-${i}
	#zip -r ${y}-${m1}-${i}.cbz ${y}-${m1}-${i}
	#lpage="$(cat issud/issuefile | sed 's|,|\n|g' | grep Length: | sed 's| pages||g' | sed 's|.*: ||g')"
	#[ -d issud ] && mv -f issud $dir
	#if [ "$(find $dir -name "*${lpage}.jpg" -type f)" ]; then
	#	zip -r $dir.cbz $dir
	#fi
	sleep 2
	fi
done
