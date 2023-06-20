#!/bin/bash


#y="2022"
#b="0005"
#b="0000008"
#https://www.cia.gov/readingroom/document/00 0000 8006
check="yes"
#for i in $(seq -w ${b}000 ${b}099); do
for i in $(cat list.txt); do
#for a in $(cat list.txt); do

#id="NASA_NTRS_Archive_${a}"
id="cia-readingroom-document-${i}"

file="${i}.pdf"
	if [ "$check" == "yes" ]; then
	url="archive.org/download/$id"
	[ -f "$url" ] || wget -x -c $url
	if [ -f "$url" ]; then
		if [ "$(grep "$(basename "$(echo "${file}" | sed "s|\[.*||g")")" $url)" != "" ]; then
			echo "$file is in $url"
			continue
		fi
	fi
	fi
[ -f $i ] || wget -c https://www.cia.gov/readingroom/document/$i

#use to grab urls ids from search pages
#cat index.html | grep href= | sed 's|.*href="||g' | sed 's|".*||g' | grep ^http | grep readingroom/document

durl="$(cat $i | grep href= | sed 's|.*href="||g' | grep ^http | tail -1 | sed 's|pdf.*|pdf|g')"
[ -f "$file" ] || wget -c "$durl" -O "$file"
find "$file" -type f -empty -delete

[ -f "$file" ] || continue

creator="CIA Reading Room"

title1="$(cat $i | grep dc:title | sed 's|.*content="||g' | sed 's|".*||g')" 

title="${creator} ${i}: ${title1}"
#desc="$(curl -s https://ntrs.nasa.gov/api/citations/${a} | grep abstract | sed 's|.*"abstract":"||g' | sed 's|",".*||g')"
desc="$(cat $i | sed 's|><|>\n<|g' | sed -n '/<div class="field-item even" property="content:encoded">/,/div>/p' | sed 's|<div class="field-item even" property="content:encoded">||g' | sed 's|</div>||g' | tr -d '\r\n' | sed 's|\x0c||g' | dos2unix)"
date="$(cat $i | sed 's|><|>\n<|g' | grep date-display-single | tail -1 | sed 's|.*content="||g' | sed 's|T.*||g')"

basekeywords="$creator;"
if [ "$desc" == "" ]; then
    desc="No Description"
fi
echo "$title"
#echo "$desc"
echo "$date"
#echo "$author"
	ia upload $id "$file" -H "x-archive-queue-derive:0" -H "x-archive-check-file:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="creator:$creator" \
		--metadata="language:english" \
		--metadata="title:$title" \
		--metadata="date:$date" \
		--metadata="description:$desc" \
		--metadata="subject:$basekeywords"


done
