#!/bin/bash

for k in 137; do #134; do #$(seq 21 23); do
for i in $(seq -w 000 999); do
for d in 07; do #$(seq 17 22); do #$(seq 21 28); do
#for a in $(cat list.txt | grep ${k}${i}$ | sed 's|.*-||g' | grep ^${k}${i}); do
#for d in $(seq -w 01 17); do #$(seq -w 16 17); do
	#urlpath="img.gizport.jp/pdf/2012-11-18/${k}${i}.pdf"
	#domain="img.gizport.jp"
	domain="153.127.246.254"
	urlpath="$domain/pdf/2013-09-${d}/${k}${i}.pdf"
	#urlpath="$domain/pdf/2013-09-${d}/${a}.pdf"
	[ -f $(dirname $urlpath) ] || mkdir -p $(dirname $urlpath)

	#if [ ! -f $url ]; then
	#	url1="$(curl -s http://gizport.jp/manual/1/?id=${k}${i} | grep nofollow | grep pdf | sed 's|.*href="||g' | sed 's|".*||g' | head -1)"
	#fi
	#http://gizport.jp/lib/download.pl?mid=29338&pdfid=0&mpid=1
	url="http://gizport.jp/lib/download.pl?mid=${k}${i}&pdfid=0&mpid=1"
	#domain="153.127.246.254"

	echo "${k}${i}.pdf"
	#[ -f $urlpath ] || wget -x -c $urlpath
	#[ -f $urlpath ] || continue
	#if [ "$(find $domain -name "${k}${i}.pdf" -type f)" == "" ]; then
	#	wget -x -c -U firefox -t 5 -T 3 $urlpath
	#fi
	if [ "$(find "$domain" -name "${k}${i}.pdf" -type f)" == "" ]; then
		echo "$urlpath"
		wget -x -c -U firefox --content-disposition -t 5 -T 2 "$url" -O "$urlpath"
	fi
	#[ -f $urlpath ] || wget -t 2 -T 2 -c $url1 -O $urlpath
done
done
done
#done

