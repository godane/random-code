#!/bin/sh

# www.dtic.mil ip address is 131.84.179.51

#k="186"
#787900 to 792xxx had nothing so jump my number range
for k in 1050; do #$(seq 990 1020); do
for i in $(seq -w ${k}000 ${k}999); do
	domain="apps.dtic.mil"
	#domain="131.84.180.30"
	path="$domain/dtic/tr/fulltext/u2"
	[ -d $path ] || mkdir -p $path
	#[ -f  $path/${i}.pdf ] || wget -x --no-check-certificate -U firefox -T 5 -t 2 -c https://$path/${i}.pdf
	wget -x --no-check-certificate -U firefox -T 5 -c https://$path/${i}.pdf
	for a in a b c p; do # a b c p; do
		#[ -f $path/${a}${i}.pdf ] || wget  -x --no-check-certificate -U firefox -T 5 -t 2 -c https://$path/${a}${i}.pdf
		#[ -f $path/${a}${i}.pdf ] || touch $path/${a}${i}.pdf
		wget -x -U firefox --no-check-certificate -T 5 -c https://${path}/${a}${i}.pdf
	done
	#bash upload.sh $i
done
done
