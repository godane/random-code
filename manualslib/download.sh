#!/bin/bash

id="$1"

if [ ! -f $id.cbz ]; then
	for p in $(seq -w 0001 9999); do
		[ -d $id ] || mkdir $id
		purl="https://data2.manualslib.com/bigImage/$id/${p}?langCode=en"
		pfile="$id/p${p}.png"
		[ -f $pfile ] || wget -c $purl -O $pfile
		find $id -size 12c -delete
		find $id -empty -delete
		[ -f $pfile ] || break
	done
	zip -r $id.cbz $id
fi
