#!/bin/bash

# borrow book then extract cookies in firefox
start="0001"
end="1999"
id="$1"
[ -d $id ] || mkdir -p $id
for p in $(seq -w $start $end); do
	#url="archive.org/download/$id/${id}_jp2.zip%2${id}_jp2.zip%2${id}_${start}.jpg"
	if [ ! -f $id/page${p}.jpg ]; then
	#https://archive.org/services/loans/beta/loan/
		urlhtml="https://archive.org/bookreader/BookReaderJSLocate.php?id=${id}&subPrefix=${id}"
		url1="$(curl -L -s  "$urlhtml" | grep url | sed "s|.*url: '//|https://|g" | sed 's|itemPath=|zip=|g' | sed 's|JSIA|Images|g' | sed "s|&server=.*||g")"
		url="$url1/${id}_jp2.zip&file=${id}_jp2/${id}_${p}.jp2&scale=1&rotate=0"
		wget --load-cookies=cookies.txt  -U firefox -c "$url" -O $id/page${p}.jpg
		curl -e http://archive.org/details/${id} -b cookies.txt -c cookies.txt -A firefox -s "https://archive.org/services/loans/beta/loan/?action=create_token&identifier=${id}&action=borrow_book"
	fi
	find $id -type f -size 0 -delete
	[ -f $id/page${p}.jpg ] || break
done
