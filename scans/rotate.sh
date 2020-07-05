#!/bin/bash

dir="$1"
lastnum="$(echo $(ls $dir | wc -l) - 2 | bc)"
for i in $(seq -w 0002 2 $lastnum); do
	find $dir -name "*${i}.jpg" -type f | sort | while read file; do
		newfile="$dir/$(basename $file .jpg)a.jpg"
		echo "rotating $file"
		convert $file -rotate 180 $newfile
		mv -f $newfile $file
	done
done

		
#mogrify -fuzz 30% -define trim:percent-background=0% -trim +repage -format jpg scan0001.jpg
