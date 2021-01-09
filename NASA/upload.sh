#!/bin/bash


y="2015"
b="0000"
check="yes"
for i in $(seq -w ${b}001 ${b}999); do

id="NASA_NTRS_Archive_${y}${i}"
file="${y}${i}.pdf"
[ -f "$file" ] || continue
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
bash download.sh ${y}${i}
creator="NASA Technical Reports Server (NTRS)"

title1="$(curl -s https://ntrs.nasa.gov/api/citations/${y}${i} | sed 's|,|\n|g' | grep title | sed 's|.*":"||g' | sed 's|".*||g')"

title="NASA Technical Reports Server (NTRS) ${y}${i}: ${title1}"
desc="$(curl -s https://ntrs.nasa.gov/api/citations/${y}${i} | grep abstract | sed 's|.*"abstract":"||g' | sed 's|",".*||g')"
date="$(curl -s https://ntrs.nasa.gov/api/citations/${y}${i} | sed 's|,|\n|g' | grep publicationDate | sed 's|T.*||g' | sed 's|.*"||g')"
author="$(curl -s https://ntrs.nasa.gov/api/citations/${y}${i}  | sed 's|","|"\n"|g' | grep author | sed 's|":"|\n|g' | sed 's|".*||g' | sort | uniq | tr '\n' ';'  | sed 's|^;||g')"


	ia upload $id "$file" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="creator:$creator" \
		--metadata="language:english" \
		--metadata="description:$desc" \
		--metadata="title:$title" \
		--metadata="subject:$author" \
		--metadata="date:$date"
done
