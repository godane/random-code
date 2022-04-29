#!/bin/bash

url="$1"
id="$(basename $(dirname "$url"))"
dir="$(basename $url)"

curl --cookie cookies.txt -s https://www.yumpu.com/document/json2/${id} > json2-${id}

basepath="$(curl --cookie cookies.txt -s https://www.yumpu.com/document/json2/${id} | sed 's|,|\n|g' | grep base_path | sed 's/\\//g' | sed 's|.*":"||g' | sed 's|".*||g' | grep ^http)"
echo $basepath
curl --cookie cookies.txt -s https://www.yumpu.com/document/json2/${id} | sed 's|,|\n|g' | sed 's/\\//g' | grep images/bg | sed 's|"||g' | sed 's|]$||g' | grep bg0${p} > list.txt


for p in $(seq -w 01 99); do

	for pp in $(cat list.txt | grep images/bg0${p}_); do
		fullurl="${basepath}${pp}"
		echo "download $p"
		[ -d $dir ] || mkdir -p $dir
		wget --load-cookies=cookies.txt -c $fullurl -O $dir/p0${p}.jpg
	done
	
done

	



