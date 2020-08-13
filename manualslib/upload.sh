#!/bin/bash


check="yes"
c="$1"
for i in $(seq ${c}00 ${c}99); do
	id="manualslib-id-${i}"
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "${i}.pdf")" $url)" != "" ]; then
				echo "${i}.pdf is in $url"
				continue
			fi
		fi
	fi
bash download.sh $i
find -name "${i}.cbz" -empty -delete
ls ${i}.cbz | while read file; do
	title1="$(curl -L -s https://www.manualslib.com/manual/$i/a.html | grep '<h1>' | tail -1 | sed 's|.*<h1>||g' | sed 's|</h1>.*||g')"
	title="$title1"


	keywords="$(curl -L -s https://www.manualslib.com/manual/$i/a.html | grep  -A10 hide_mobile | grep 'li><' | sed 's|.*">||g' | sed 's|<.*||g')"
	keyword="$(curl -L -s https://www.manualslib.com/manual/$i/a.html | grep -A1 '<div class="itemsdescr">' | sed 's|^                        ||g' | tail -1 | sed 's|  .*||g')"

	basekeywords="manualslib; manuals; ${keyword}; ${keywords}"

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
done
