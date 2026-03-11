#!/bin/bash


#y="2022"
b="00954"
#b=""
#https://www.cia.gov/readingroom/document/00 0000 8006
check="yes"
#for i in $(seq -w ${b}260 ${b}269); do
#c="5076de59993247d4d82b5a6"
#for d in $(seq -w 0 9) a b c d e f; do
#i="${c}${d}"
for i in $(cat list.txt); do
#ls *.html | sed 's|.html$||g' | while read i; do
#for a in $(cat list.txt); do

#id="NASA_NTRS_Archive_${a}"
id="cia-readingroom-document-${i}"
useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
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
#[ -f $i ] || wget --user-agent="$useragent" -c https://www.cia.gov/readingroom/document/$i
[ -f $i ] || chromium --headless --disable-web-security=false --user-data-dir=chrome-data --dump-dom  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" https://www.cia.gov/readingroom/document/$i > $i

#use to grab urls ids from search pages
#cat index.html | grep href= | sed 's|.*href="||g' | sed 's|".*||g' | grep ^http | grep readingroom/document

durl="$(cat ${i} | grep href= | sed 's|.*href="||g' | grep ^http | tail -1 | sed 's|pdf.*|pdf|g')"
[ -f "$file" ] || wget --user-agent="$useragent" -c "$durl" -O "$file"
#[ -f "$file" ] || chromium --headless --disable-web-security=false --user-data-dir=chrome-data  --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$durl" > "$file"

find "$file" -type f -empty -delete

[ -f "$file" ] || continue

creator="CIA Reading Room"

title1="$(cat $i | grep dc:title | sed 's|.*content="||g' | sed 's|".*||g')" 

title="${creator} ${i}: ${title1}"
#desc="$(curl -s https://ntrs.nasa.gov/api/citations/${a} | grep abstract | sed 's|.*"abstract":"||g' | sed 's|",".*||g')"
desc="$(cat ${i} | sed 's|><|>\n<|g' | sed -n '/<div class="field-item even" property="content:encoded">/,/div>/p' | sed 's|<div class="field-item even" property="content:encoded">||g' | sed 's|</div>||g' | tr -d '\r\n' | sed 's|\x0c||g' | dos2unix)"
date="$(cat ${i} | sed 's|><|>\n<|g' | grep date-display-single | tail -1 | sed 's|.*content="||g' | sed 's|T.*||g')"

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
