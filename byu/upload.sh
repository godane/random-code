#!/bin/bash


#https://www.byuradio.org/api/uihelper/getpaginatedepisodes?year=2015&page=13&showguid=e9a84fc9-4bb1-476f-bd5d-0e907b754af8&context=Web%24Global%24Release

metaurl="https://www.byuradio.org/api/uihelper/getpaginatedepisodes?year=2015&page=10&showguid=e9a84fc9-4bb1-476f-bd5d-0e907b754af8&context=Web%24Global%24Release"
y="2015"
m="04"
check="yes"
find ${y}/${m} -type f | sort | while read file; do
	date="$(curl -s "$metaurl" | grep -B10 $(basename $file) | grep premiereDate | sed 's|.*: "||g' | sed 's|".*||g' | sed 's|T.*||g')"
	[ -f $file ] || continue
	id="byu-radio-top-of-the-mind-with-julie-rose-${date}"
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "$file")" $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi
	desc="$(curl -s "$metaurl" | grep -B10 $(basename $file) | grep shortDesc | sed 's|.*: "||g' | sed 's|".*||g')"
	title1="$(curl -s "$metaurl" | grep -B10 $(basename $file) | grep title | sed 's|.*: "||g' | sed 's|".*||g')"
	name="Top of Mind With Julie Rose"
	title="${name} ${date} : $title1"
	creator="BYU Radio"
	basekeywords="${name}; Julie Rose; ${creator};"
	
	ia upload $id "$file" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="creator:$creator" \
		--metadata="title:$title" \
		--metadata="date:$date" \
		--metadata="description:$desc" \
		--metadata="language:english" \
		--metadata="subject:${basekeywords}"
done
