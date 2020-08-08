#!/bin/sh

accesskey="Wrs3QiEcY53IjH1q"
secret="4hkB0O1AihzTL6hF"
#order="04 11 18 25"
#m="05"
#y="08"
#basename="giantbombcast"
check="yes"
year="2020"
bucket="x-amz-auto-make-bucket:1"
for m in 03; do
for i in $(seq -w 14 31); do #$(seq -w 19 30); do #$(seq 3 31); do #$(seq -w 26 28); do
filelist="$(find $year/$m/$i -type f -size +1M | sort)"
for file in $filelist; do
	id="kpfa-archives-radio-podcast-${year}-${m}-${i}"
	#file="${m}/$id.mp3"
	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep $(basename $file) $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi
	[ -f "$file" ] || continue
	basekeywords="KPFA; 94.1FM;"
	#date1="$(cat *.rss | grep -B11 $id.mp3 | grep pubDate | sed 's|.*<pubDate>||g' | sed 's|</pubDate>||g')"
	date="$year-$m-$i"
	title="KPFA Archives Radio Podcast - ${year}/${m}/$i"
	#desc="$(cat *.rss | grep -B11 $id.mp3 | grep '<description>' | sed 's|.*<description>||g' | sed 's|</description>||g')"
	creator="KPFA"
	#ia metadata $id --modify="collection:godaneinbox" --modify="mediatype:audio" --modify="date:$date" --modify="language:english" --modify="title:$title" --modify="subject:${basekeywords}"
	ia upload $id "$file" -H "x-archive-queue-derive:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:audio" \
		--metadata="creator:$creator" \
		--metadata="language:english" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}"
		

done
done
done
