#!/bin/sh

ext="pdf"
check="yes"
for i in $(seq 137000 137999); do
	
	id="japanese-manual-$i"
	domain="153.127.246.254"
	findfile="$(find $domain -type f -name "${i}.pdf")"
	file="$findfile"
	[ -f "$file" ] || continue
	[ "$(file $file | grep PDF)" != "" ] || continue

	[ -f "$file" ] || continue
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep $id.${ext} $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi
	title1="$(curl -L -s http://gizport.jp/manual/1/?id=$i | grep '<title>' | head -1 | sed 's|<title>||g' | sed 's|</title>||g' | dos2unix)"
	desc="$(curl -L -s http://gizport.jp/manual/1/?id=$i | grep description | head -1 | sed 's|.*content="||g' | sed 's|".*||g' | dos2unix)"
	title="japanese manual $i : $title1"
	#brand="$(curl -s gizport.jp/manual/1/?id=$i | grep support | grep -v selected | tail -1 | sed 's|.*support/||g' | sed 's|".*||g')"
	#echo $brand
	#date="${y}"
	basekeywords="japanese manuals; $brand;"
	
	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
			--metadata="collection:godaneinbox" \
			--metadata="mediatype:texts" \
			--metadata="title:$title" \
			--metadata="description:$desc" \
			--metadata="language:japanese" \
			--metadata="subject:${basekeywords}"

done
#done
#done
