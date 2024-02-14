#!/bin/bash


#cat index.txt | while read file; do echo "<a href="$(dirname $file)">$(dirname $file)</a>" >> index.html; done

#k="2366"
id="$1"
#ip="$2"
check="yes"
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
sed -i "s|manualzz.com.*|manualzz.com/doc/${id}/a/\",|g" scraper.sh
sed -i "s|HTML|${id}.html|g" scraper.sh
bash scraper.sh
sed -i "s|${id}.html|HTML|g" scraper.sh
url="$(cat ${id}.html | sed 's| src=|\ndata-src=|g' | grep -v googleads.g.doubleclick | grep manualzz.com | grep pdf | sed 's|%2F|/|g'  | sed 's|%3D|=|g'  | sed 's|%3F|?|g' | sed 's|%26|\&|g' | sed 's|\&img=.*||g' | sed 's|.*file=//|http://|g' | tail -1 | sed 's|&amp;.*||g')"
echo "sleep 1"
sleep 1
if [ "$download" == "true" ]; then
echo "downloading ${file}"
if [ ! -f $file ]; then
for a in $(seq 1 19); do
echo "try $a"
timeout 5 wget -T 3 -U "$useragent" --no-check-certificate -e robots=off -c $url -O ${file} -a ${id}.log
if [ "$(cat ${id}.log | grep ' saved \[')" != "" ]; then
	break
fi
done
wget -T 3 -U "$useragent" --no-check-certificate -e robots=off -c $url -O ${file}
fi
if [ -f wget-log ]; then
rm wget-log
fi
fi
#code for title for upload script
#curl -s https://manualzz.com/doc/1509832/ | grep title | sed 's|.*title="||g' | sed 's|".*||g' | tail -1
fi

