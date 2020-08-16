#!/bin/bash

id="$1"

decrypt="y"
if [ ! -f $id.pdf ]; then
	for p in $(seq -w 0001 9999); do
		[ -d $id ] || mkdir $id
		purl="https://www.manualslib.com/printPage?manual_id=${id}&page=${p}"
		pfile="$id/p${p}.pdf"
		
		#example code
		#for i in $(seq -w 727 784); do wget --referer https://www.manualslib.com/ -T 5 "https://www.manualslib.com/printPage?manual_id=116&page=${i}_blank" -O p${i}.pdf; done

		[ -f $pfile ] || wget --referer http://www.manualslib.com/ --no-check-certificate -T 10 -c $purl -O $pfile
		find $id -size 12c -delete
		find $id -size -4k -delete
		find $id -empty -delete

		[ -f $pfile ] || break
		if [ "$decrypt" == "y" ]; then
			if [ "$(pdfinfo $pfile | grep Encrypted: | grep yes)" != "" ]; then
				qpdf --decrypt $pfile "$id/$(basename $pfile .pdf)-fix.pdf"
			fi
		fi
	done
	totalp="$(curl -L -s https://www.manualslib.com/manual/$id/a.html | grep -i 'print document' | sed 's|.*(||g' | sed 's| .*||g')"
	if [  "$(find $id -name "*0${totalp}.pdf" -type f)" != "" ]; then
		if [ "$(ls $id | wc -l)" != "1" ]; then
			if [ "$decrypt" == "y" ]; then
				pdfunite $id/*-fix.pdf ${id}.pdf
			else
				pdfunite $id/*.pdf ${id}.pdf
			fi
		else
			cp $id/p0001.pdf $id.pdf
		fi
		if [ -d $id -a $id.pdf ]; then
			rm -rf $id
		fi
	else
		echo "$id is incomplete" >> incomplete.txt
	fi
fi
