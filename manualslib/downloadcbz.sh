#!/bin/bash

id="$1"

if [ ! -f $id.cbz ]; then
	totalp="$(curl -L -s https://www.manualslib.com/manual/$id/a.html | grep -i 'print document' | sed 's|.*(||g' | sed 's| .*||g')"
	if [ "$(curl -L -s https://www.manualslib.com/manual/$id/a.html?page=${totalp} | sed 's|><|>\n<|g' | grep '<h2>Table')" != "" ]; then
		total=$(echo "${totalp} - 1" | bc)
	else
		total="${totalp}"
	fi
	if [ "$(echo $total | wc c)" -lt "4" ]; then
	for p in $(seq 1 $total); do
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

	if [ "$(echo $total | wc -c)" == "2" ]; then
		total1="000${total}"
	elif [ "$(echo $total | wc -c)" == "3" ]; then
		total1="00${total}"
	elif  [ "$(echo $total | wc -c)" == "4" ]; then
		total1="0${total}"
	else
		total1="{total}"
	fi
	if [  "$(find $id -name "p${total1}.png" -type f)" != "" ]; then
		zip -r $id.cbz $id
		if [ -d $id -a $id.cbz ]; then
			rm -rf $id
		fi
	else
		echo "$id is incomplete" >> incomplete.txt
	fi
	else
		echo "$id is more then 99 pages." >> incomplete.txt
	fi
fi
