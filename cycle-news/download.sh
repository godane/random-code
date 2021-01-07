#!/bin/bash

k="127"
#a="41652"
#a="46071"
a="46075"
for i in $(seq 394 499); do #$(seq -w 970 999); do #$(seq -w 039 066); do #$(seq 100 220); do
	curl="https://magazine.cyclenews.com/read/flipbook3_title_settings/${a}/${k}${i}"
	id="$(curl -s $curl | grep pdf | sed 's|.*uri">||g' | sed 's|</item>||g')"
	if [ "$id" != "" ]; then
		pdfurl="https://content.cdntwrk.com/files/$id"
		wget --content-disposition $pdfurl
	else
		echo "nothing at ${k}${i}"
	fi
done
	
