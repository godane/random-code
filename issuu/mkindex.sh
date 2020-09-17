#!/bin/bash

user="switchplayer"
number="$(curl -s "https://search.issuu.com/api/2_0/document?q=username:${user}" | sed 's|, |\n|g' | grep numFound | sed 's|.*: ||g')"

for i in $(seq 0 ${number:0:2}); do
	echo "$user startindex ${i}0"
curl -s "https://search.issuu.com/api/2_0/document?q=username:${user}&startIndex=${i}0&sortBy=epoch" | sed "s|, |\n|g" | grep docname | sed 's|.* "||g' | sed 's|".*||g' >> index.txt
done
