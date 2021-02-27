#!/bin/bash

#k="2366"
id="$1"
file="${id}.pdf"
if [ ! -f $file ]; then
[ -f ${id}.html ] || wget -U firefox -e robots=off -c https://manualzilla.com/doc/${id}/ -O ${id}.html
url="$(cat ${id}.html | grep pdf | sed 's|%2F|/|g' | sed 's|%3D|=|g' | sed 's|%3F|?|g'  | sed 's|%26|\&|g' | sed 's|\&img=.*||g' | sed 's|.*file=//|http://|g' | grep ^http)"
#echo "sleep 5"
#sleep 5
echo "downloading ${file}"
[ -f $file ] || wget -U firefox -e robots=off -c $url -O ${file}
if [ -f $file ]; then
t="20"
#echo "sleep $t"
#sleep $t
fi
#code for title for upload script
#curl -s https://manualzz.com/doc/1509832/ | grep title | sed 's|.*title="||g' | sed 's|".*||g' | tail -1
fi

