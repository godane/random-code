#!/bin/bash

#http://news.kbs.co.kr/news/getHlsNewsVodUrl.do?vodUrl=news9_history/1987/19870101/1500K_new/10.mp4&

#http://news.kbs.co.kr/news/getExistNews.do?SEARCH_SECTION=0001&SEARCH_CATEGORY=0001&SEARCH_DATE=1987.01.02&SEARCH_DATE_TYPE=DATE&SEARCH_MODE=listByVodDateNoPage&SEARCH_MENU_CODE=&SEARCH_BROAD_CODE=0001&
y="1987"
for m in $(seq -w 01 12); do
	for d in $(seq -w 01 31); do
		for p in $(seq 1 99); do
		url="http://news.kbs.co.kr/news/getHlsNewsVodUrl.do?vodUrl=news9_history/${y}/${y}${m}${d}/1500K_new/${p}0.mp4"
		surl="$(curl -s $url | sed 's|,|\n|g' | sed 's|.*":"||g' | sed 's|".*||g' | head -1)"
		if [ "$(echo $p | wc -c)" == "2" ]; then
			p1="00${p}"
		elif [ "$(echo $p | wc -c)" == "3" ]; then
			p1="0${p}"
		else
			p1="${p}"
		fi
		path="$y/$m/$d"
		[ -d $path ] || mkdir -p $path
		file="$path/${p1}0.mp4"
		[ -f $file ] || wget -c $surl -O $file
		[ -f $file ] || break
		done
	done
done

		
