#!/bin/bash

#k="2366"
for id in $(seq 100 999); do
t="10"
sleep $t
echo "sleep $t"
url="$(curl -s https://manualzz.com/doc/${id}/ | grep pdf | grep data-src= | sed 's|%2F|/|g' | sed 's|%3D|=|g' | sed 's|%3F|?|g'  | sed 's|%26|\&|g' | sed 's|\&img=.*||g' | sed 's|.*file=//|http://|g')"

file="${id}.pdf"
echo "downloading ${file}"
[ -f $file ] || wget -c $url -O ${file}
#code for title for upload script
#curl -s https://manualzz.com/doc/1509832/ | grep title | sed 's|.*title="||g' | sed 's|".*||g' | tail -1
done

