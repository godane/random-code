#!/bin/bash

y="2016"
website="kotaku.com"
for m in 12; do
	for d in $(seq -w 01 31); do
		url="https://$website/sitemap_bydate.xml?startTime=${y}-${m}-${d}T00:00:00&endTime=${y}-${m}-${d}T23:59:59"
		dir="$y/$m/$d"
		[ -d $dir ] || mkdir -p $dir
		curl -s "$url" |  sed "s|.*\[||g" | sed "s|].*||g" | sed 's|.*http|http|g' | sed 's|<.*||g' | sort | uniq > $dir/index.txt
		echo "$url" >> $dir/index.txt
		wget -x -i $dir/index.txt --warc-file=$dir/${website}-sitemap-${y}-${m}-${d}-$(date +%Y%m%d) --warc-cdx -o $dir/wget.log -P $dir
	done
done
