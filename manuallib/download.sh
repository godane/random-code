#!/bin/bash

for i in $1; do
if [ "${i}" != "" ]; then
url="https://www.manuallib.com/file/$i"
[ -f ${i}.html ] || wget -c $url -O ${i}.html

pdfurl="$(cat ${i}.html | grep Download | sed 's|.*href="||g' | sed 's|".*||g' | grep ^http)"

[ ${i}.pdf ] || wget -c $pdfurl -O ${i}.pdf
fi
done

