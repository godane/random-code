#!/bin/sh

creator="Tokyo FM"
show="SUNTORY SATURDAY WAITING BAR AVANTI PODCAST"
show1="avanti"
idname="tokyo-fm-${show1}"

for i in $(seq 1 365); do
ls *vol${i}.mp3 | while read file; do
	[ -f $file ] || break
	
	id="${idname}-${i}"
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep $(basename $file) $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi
	#https://www.tfm.co.jp/podcasts/avanti/podcast.xml
	desc="$(cat *.xml | sed 's|><|>\n<|g' | grep -A5 $file | grep -A1 '<description>' | sed 's|.*CDATA\[||g' | sed 's|].*||g' | tail -1)"
	
	title="${show} vol ${i}"

	date1="$(cat *.xml | sed 's|><|\n|g' | grep -A5 $file1 | grep '<pubDate>' | sed 's|.*<pubDate>||g' | sed 's|</pubDate>.*||g')"
	date="$(date -d "$date1" +%Y-%m-%d)"
	basekeywords="${creator}; ${show}; ${show1};"

	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="creator:$creator" \
		--metadata="language:japanese" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}" 
done
done
#done
