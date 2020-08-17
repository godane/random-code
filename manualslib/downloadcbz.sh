#!/bin/bash

id="$1"

if [ ! -f $id.cbz ]; then
	totalp="$(curl -L -s https://www.manualslib.com/manual/$id/a.html | grep -i 'print document' | sed 's|.*(||g' | sed 's| .*||g')"
	for p in $(seq 1 9999); do
		if [ "$(echo $p | wc -c)" == "2" ]; then
			p1="000${p}"
		elif [ "$(echo $p | wc -c)" == "3" ]; then
			p1="00${p}"
		elif [ "$(echo $p | wc -c)" == "4" ]; then
			p1="0${p}"
		fi
		[ -d $id ] || mkdir $id
		purl="https://data2.manualslib.com/bigImage/$id/${p}?langCode=en"
		pfile="$id/p${p1}.png"
		[ -f $pfile ] || wget --no-check-certificate -T 10 -c $purl -O $pfile
		find $id -size 12c -delete
		find $id -empty -delete
		[ -f $pfile ] || break
	done

	if [ "$(echo $totalp | wc -c)" == "2" ]; then
		totalp1="000${totalp}"
	elif [ "$(echo $totalp | wc -c)" == "3" ]; then
		totalp1="00${totalp}"
	elif  [ "$(echo $totalp | wc -c)" == "4" ]; then
		totalp1="0${totalp}"
	else
		totalp1="{totalp}"
	fi
	if [  "$(find $id -name "p${totalp1}.png" -type f)" != "" ]; then
		zip -r $id.cbz $id
		if [ -d $id -a $id.cbz ]; then
			rm -rf $id
		fi
	else
		echo "$id is incomplete" >> incomplete.txt
	fi
fi
