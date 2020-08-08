#!/bin/bash


#k="6"
#for k in 141; do #$(seq 140 142); do #$(seq 58 61); do
#for i in $(seq -w 000 999); do
id="$1"
	#file="${k}${i}.pdf"
	file="${id}.pdf"
	#way to grab title from html page
	#curl -s http://www.manualsbase.com/manual/62000/1/1/1/ | grep title | sed 's|.*<title>||g' | sed 's| - ManualsBase.com.*||g' | head -1
	if [ ! -f $file ]; then
	pdfurl="$(curl -s http://www.manualsbase.com/manual/${id}/1/1/1/ | grep -a pdf | sed 's|.*downloadmanual||g' | sed 's|.*#../|http://www.manualsbase.com/|g'  | sed 's|pdf".*|pdf|g' | grep -a ^http | head -1 | sed 's|#39;||g' | sed 's|&||g')"
	echo "$pdfurl"
	echo "${id}"
	[ -f $file ] || wget -c --referer http://www.manualsbase.com/viewerjs/pdf.worker.js "$pdfurl" -O ${file}
	fi
	#[ -f $file ] || wget -c --referer http://www.manualsbase.com/viewerjs/pdf.worker.js http://www.manualsbase.com/manual/manualfileaspdf/${k}${i} -O ${file}
#done
#done

