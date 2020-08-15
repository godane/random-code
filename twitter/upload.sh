#!/bin/bash

#snscrape twitter-user user > user.txt
#curl --upload-file user.txt https://transfer.notkiska.pw/user.txt

check="yes"
if [ "$1" == "" ]; then
for i in $(cat list.txt); do
	if [ "$check" == "yes" ]; then
		url="archive.org/download/twitter-$(basename ${i})"

		echo $url
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			continue
		fi
	fi
tubeup $i --metadata="collection:godaneinbox"
done
else
tubeup $1 --metadata="collection:godaneinbox"
fi
