#!/bin/bash

brand="$1"
curl -s https://www.manualslib.com/brand/${brand}/ | grep /brand/ | sed 's|.*href="|https://www.manualslib.com|g' | sed 's|".*||g' | sort | uniq | grep www.manualslib.com/brand/${brand}/ > pages.txt


for url in $(cat pages.txt); do
	echo "$url"
	curl -s $url | grep manual/ | sed 's|.*/manual/||g' | sed 's|/.*||g' | sort | uniq >> ${brand}-unsorted.txt
done

cat ${brand}-unsorted.txt | sort | uniq > ${brand}.txt
if [ -f  ${brand}-unsorted.txt ]; then
	rm  ${brand}-unsorted.txt
fi
