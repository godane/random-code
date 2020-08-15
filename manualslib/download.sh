#!/bin/bash

id="$1"

if [ ! -f $id.cbz ]; then
	for p in $(seq -w 0001 9999); do
		[ -d $id ] || mkdir $id
		purl="https://data2.manualslib.com/bigImage/$id/${p}?langCode=en"
		pfile="$id/p${p}.png"
		[ -f $pfile ] || wget -no-check-certificate -T 10 -c $purl -O $pfile -o $id-wget.log
		find $id -size 12c -delete
		find $id -empty -delete
		[ -f $pfile ] || break
	done
	totalp="$(curl -L -s https://www.manualslib.com/manual/$id/a.html | grep -i 'print document' | sed 's|.*(||g' | sed 's| .*||g')"
	if [  "$(find $id -name "*0${totalp}.png" -type f)" != "" ]; then
		zip -r $id.cbz $id
		if [ -d $id -a $id.cbz ]; then
			rm -rf $id
		fi
	else
		echo "$id is incomplete" >> incomplete.txt
	fi
fi
