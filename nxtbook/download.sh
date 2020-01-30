#!/bin/bash

#y="2006"
for y in $(seq 2009 2015) $(seq 2017 2020); do #$(seq 1970 1979); do
for m in $(seq -w 01 12); do
	#for p in $(seq -w 001 199); do
		pub="musicmaker"
		mag="recording"
		dirbase="${mag}_${y}${m}"
		#dirbase="${mag}${m}${y:2:4}"
		#http://transfer.nxtbook.com/nxtbooks/musicmaker/recording_201612/offline/musicmaker_recording_201612.pdf
		[ -f ${pub}_${dirbase}.pdf ] || wget -T 2 -c http://transfer.nxtbook.com/nxtbooks/${pub}/${dirbase}/offline/${pub}_${dirbase}.pdf
		#url="http://pages.nxtbook.com/nxtbooks/${mag}/${dirbase}/iphone/${mag}_${dirbase}_p0${p}_hires.jpg"
		#[ -d $dirbase ] || mkdir $dirbase
		#[ -f $dirbase/p${p}.jpg ] || wget -c $url -O $dirbase/p${p}.jpg
		#find $dirbase/p${p}.jpg -type f -size 0 -delete
		#[ -f $dirbase/p${p}.jpg ] || break
	#done
done
done
