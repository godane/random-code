#!/bin/bash

url="$1"

brand="twelvevolt"

curl -s http://www.manualsonline.com/brands/$brand | grep -A1 manual-cta | grep $brand | grep product_list | sed 's|.*href="||g' | sed 's|".*||g' | sort | uniq > plist.txt

for url in $(cat plist.txt); do
	#curl -s $url | grep manuals/mfg/$brand | grep '<li>' | sed 's|.*href="||g' | sed 's|".*||g' > mlist.txt
	curl -L -s $url | grep '<h5>' | grep href= | sed 's|.*href="|www.manualsonline.com|g' | sed 's|".*||g' > mlist.txt
	for murl in $(cat mlist.txt); do
		echo $murl
		curl -L -s $murl | grep pdfstream | grep pdfstream | sed 's|.*href="||g' | sed 's|".*||g' > pdfurls.txt
		for pdfurl in $(cat pdfurls.txt); do
			id1="$(basename $pdfurl .pdf)"
			id="manualsonline-id-$id1"
			title="$(curl -L -s $murl | grep '<title>' | head -1 | sed 's|.*<title>||g' | sed 's| \| .*||g')"
			echo $id
			echo "$title"
			file="$(basename $pdfurl)"
			[ -f $file ] || wget -c $pdfurl
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
			basekeywords="manualsonline; manuals; ${brand};"

		ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
			--metadata="collection:godaneinbox" \
			--metadata="mediatype:texts" \
			--metadata="title:$title" \
			--metadata="subject:${basekeywords}"
		done
	done
done

		
