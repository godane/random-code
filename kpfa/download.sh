#!/bin/bash

y="2019"
#m="07"

#proxy: 198.100.148.55:3128 31.173.74.73:8080 183.111.169.202:3128 213.136.79.124:80 209.34.18.162:3128 85.143.24.70:80

if [ "$1" == "" ]; then
	#days="$(seq -w 30 31)"
	days="$(seq -w 07 10)"
	#days="$(seq -w 29 31)"
else
	days="$1"
fi

#if [ "$1" == "" ]; then
	#ip_proxy="94.23.200.49:3128"
#	ip_proxy=""
#else
#	ip_proxy="$1"
#fi
if [ "$3" == "" ]; then
	hours="$(seq -w 00 23)"
else
	hours="$3"
fi
for m in 09; do
#for d in $(seq -w 01 31); do
for d in $days; do
	#for i in Tue Wed Thu Fri Sat Sun Mon; do
	if [ "$d" == "01" -o "$d" == "08" -o "$d" == "15" -o "$d" == "22" -o "$d" == "29" ]; then
		i="Sun"
	elif [ "$d" == "02" -o "$d" == "09" -o "$d" == "16" -o "$d" == "23" -o "$d" == "30" ]; then
		i="Mon"
	elif [ "$d" == "03" -o "$d" == "10" -o "$d" == "17" -o "$d" == "24" -o "$d" == "31" ]; then
		i="Tue"
	elif [ "$d" == "04" -o "$d" == "11" -o "$d" == "18" -o "$d" == "25" ]; then
		i="Wed"
	elif [ "$d" == "05" -o "$d" == "12" -o "$d" == "19" -o "$d" == "26" ]; then
		i="Thu"
	elif [ "$d" == "06" -o "$d" == "13" -o "$d" == "20" -o "$d" == "27" ]; then
		i="Fri"
	elif [ "$d" == "07" -o "$d" == "14" -o "$d" == "21" -o "$d" == "28" ]; then
		i="Sat"
	fi
	
	for h in $hours; do
	for min in 00 30; do
		#if [ "$ip_proxy" == "" ]; then
		#if [ "${h}" == "07" ]; then
		#	ip_proxy="178.33.132.31:8080"
		#elif [ "${h}" == "09" ]; then
		#	ip_proxy="122.76.249.2:8118"
		#elif [ "${h}" == "12" ]; then
		#	ip_proxy="87.236.214.93:3128"
		#elif [ "${h}" == "13" ]; then
		#	ip_proxy="31.173.74.73:8080"
		#elif [ "${h}" == "14" ]; then
		#	ip_proxy="159.182.4.53:80"
		#fi
		#fi
		file="${y}${m}${d}-${i}${h}${min}.mp3"
		[ -d $d ] || mkdir -p $d
		if [ "$ip_proxy" == "" ]; then
			[ -f $d/$file ] || wget -c -e robots=off --no-check-certificate https://archives.kpfa.org/data/$file -O $d/$file
		else
			[ -f $d/$file ] || wget -c -e robots=off -U firefox -e use_proxy=yes -e http_proxy=$ip_proxy https://archives.kpfa.org/data/$file -O $d/$file
		fi
	done
	done
done
done
