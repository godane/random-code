#!/bin/bash

for a in $(cat list.txt); do
	id="$(basename $a)"
	#img2pdf --output $id.pdf $id/*jpg
	cd "$id"
	find -name "*jpg" -type f | sort | sed 's|./||g' | while read j; do
		pagesize="$(file "$j" | sed 's|, |\n|g' | grep x | tail -1)"
		echo "${id}-${j}.pdf"
		img2pdf --output="${id}-$j.pdf" --pagesize "$pagesize" "$j"
	done
	cd ../
done
[ -f "${id}.pdf" ] || pdfunite "$id"/*.pdf "${id}.pdf"
