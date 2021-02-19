#!/bin/bash


#cat index.txt | while read file; do echo "<a href="$(dirname $file)">$(dirname $file)</a>" >> index.html; done

#k="2366"
id="$1"
#ip="$2"
#check="yes"
download="true"
if [ "$ip" != "" ]; then
    proxy="-e use_proxy=yes -e http_proxy="$ip" -e https_proxy="$ip""
fi
file="${id}.pdf"
if [ "$check" == "yes" -a ! -f "${id}.pdf" ]; then
	url1="archive.org/download/manualzz-id-$id"
	echo "$url1"
	[ -f "$url1" ] || wget -x -c $url1
	if [ -f "$url" ]; then
		if [ "$(grep "$(basename "${id}.pdf")" $url1)" != "" ]; then
			echo "${id}.pdf is in $url1"
			exit
		fi
	fi
fi
if [ ! -f $file -a ! -f archive.org/download/manualzz-id-${id} ]; then
#brave-browser --headless --dump-dom --all-renderers --allow-running-insecure-content --user-agent firefox https://manualzz.com/doc/$id/ > ${id}.html
useragent="Mozilla/5.0 (X11; Linux i686; rv:84.0) Gecko/20100101 Firefox/84.0."
#[ -f ${id}.html ] ||  wget -U "$useragent" --no-check-certificate -e robots=off $proxy -c https://manualzz.com/doc/${id}/ -O ${id}.html
[ -f ${id}.html ] || bash ./save_page_as -b firefox --load-wait-time 12 --save-wait-time 3  -d ${id}.html https://manualzz.com/doc/${id}/
url="$(cat ${id}.html | grep pdf | grep data-src= | sed 's|%2F|/|g' | sed 's|%3D|=|g' | sed 's|%3F|?|g'  | sed 's|%26|\&|g' | sed 's|\&img=.*||g' | sed 's|.*file=//|http://|g')"
echo "sleep 1"
sleep 1
if [ "$download" == "true" ]; then
echo "downloading ${file}"
[ -f $file ] || wget -T 3 -U "$useragent" --no-check-certificate -e robots=off $proxy -c $url -O ${file}
if [ -f $file ]; then
if [ "$2" != "" ]; then
    t="$2"
else
    t="20"
fi
echo "sleep $t"
sleep $t
fi
fi
#code for title for upload script
#curl -s https://manualzz.com/doc/1509832/ | grep title | sed 's|.*title="||g' | sed 's|".*||g' | tail -1
fi

