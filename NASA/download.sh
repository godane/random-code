#!/bin/bash


#https://ntrs.nasa.gov/api/citations/20100029597/downloads/20100029597.pdf

#k="2015"
#b="0000"
#for i in $(seq -w 000 999); do
#id="${k}${b}${i}"
id="$1"
	url="https://ntrs.nasa.gov/api/citations/${id}/downloads/${id}.pdf"
	id="NASA_NTRS_Archive_${id}"
	aurl="archive.org/download/$id"
	[ -f $aurl ] || wget -c $aurl
	[ -f $aurl ] || wget -c $url
#done
