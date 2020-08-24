#!/bin/bash

url="$1"

check="yes"
idup="y"
brand="$1"

[ -d $brand ] || mkdir -p $brand
brandurl="www.manualsonline.com/brands/$brand"

if [ ! -f $brand/$brandurl ]; then
wget $brandurl -r --no-parent -l 3 --accept-regex="(product_list|/$brand/${brand}_|product_list.html?p=)" --reject-regex="(/social_auth/|&l=|/support/)" -H -D manualsonline.com -P $brand
fi

for url in $(find $brand -name "*product_list.html*" -type f | grep manuals/mfg/$brand/ | sort); do
	cat $url | grep '<h5>' | sed 's|.*href="|www.manualsonline.com|g' | sed 's|".*||g' | grep ^www >> $brand/mlist-unsorted.txt
done

cat $brand/mlist-unsorted.txt | sort | uniq > $brand/mlist.txt

for murl in $(cat $brand/mlist.txt); do
	echo $murl
	[ -f $brand/$murl ] || wget -x -c $murl -P $brand
	pdfid="$(cat $brand/$murl | grep pdfasset | grep thumbbase | sed 's|-thumb-.*||g'  | sed 's|.*/||g' | sort | uniq)"
	echo "$pdfid" >> $brand/pdfids.txt
	pdfurls="http://dl.owneriq.net/${pdfid:0:1}/${pdfid}.pdf"
		for pdfurl in $pdfurls; do
			id1="$(basename $pdfurl .pdf)"
			id="manualsonline-id-$id1"
			echo $id
			#echo "$title"
			file="$brand/$(basename $pdfurl)"
			if [ "$idup" = "y" ]; then
				touch $brand/ids.txt
				if [ "$(grep $id $brand/ids.txt)" != "" ]; then
					echo "$id was recently uploaded."
					continue
				fi
			fi
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
			title="$(cat $brand/$murl | grep '<title>' | head -1 | sed 's|.*<title>||g' | sed 's| \| .*||g')"

			[ -f $file ] || wget -c $pdfurl -O $file

			basekeywords="manualsonline; manuals; ${brand};"

		ia upload $id "$file" -H "x-archive-check-file:0" -H "x-archive-queue-derive:0" \
			--metadata="collection:godaneinbox" \
			--metadata="mediatype:texts" \
			--metadata="title:$title" \
			--metadata="subject:${basekeywords}"

			if [ "$idup" == "y" ]; then 
				echo "$id" >> $brand/ids.txt
			fi
		done
	done
#done

		
