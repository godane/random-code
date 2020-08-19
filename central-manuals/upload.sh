#!/bin/bash


check="yes"
ext="pdf"
brand="arri"
gear="camcorder"

turl="https://www.central-manuals.com/instructions_manual_user_guide_${gear}/${brand}.php"

bash download.sh $turl

ls *.${ext} | while read file; do
	#id1="$(curl -s $url | grep $file | grep -v "meta name=" | sed 's|.*download/||g' | sed 's|".*||g' | sed 's|/|_|g' | sed 's|(|_|g' | sed 's|)|_|g' | sed 's|\&|_|g' | sed "s|'|_|g" | sed 's|.pdf$||g')"
	id1="${gear}_${brand}_${file}"
	id="central-manuals-$id1"

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

	title1="$(curl -L -s $turl | grep $file | sed 's|.*">||g' | sed 's|<.*||g')"
	echo "$title1"
	title="${brand} - ${gear} - ${title1}"
	basekeywords="central-manuals; manuals; ${brand}; ${gear};"

	ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
done
