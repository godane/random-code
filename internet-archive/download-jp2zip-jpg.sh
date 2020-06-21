#!/bin/bash

for i in $(cat list.txt); do
jp2file="$(curl -s $i | grep jp2.zip | sed 's|.*href="|https://archive.org|g' | sed 's|".*||g' | tail -1)"
id=$(basename $i)
if [ ! -d $id ]; then
[ -d $id ] || mkdir -p $id
echo "make list from $jp2file/"
wget -U firefox "$jp2file/" -O $id/index.html
cat $id/index.html | sed 's|><|>\n<|g' | grep jpg | sed 's|.*href="|https:|g' | sed 's|".*||g' | grep jpg$ > $id/list.txt
echo "download list of $jp2file"
wget -c -i $id/list.txt -P $id
fi
done

#for get pagesize
#file *001.jpg | sed 's|, |\n|g' | grep x | tail -1

