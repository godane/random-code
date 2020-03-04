#!/bin/bash

lowerdir="$1"
upperdir="$2"
workdir="$3"
union="$4"

#if [ "$(echo "$lowerdir" | grep :)" != "" ]; then
#	for i in $(echo "$lowerdir" | sed 's|:| |g'); do
#		if [ -d "$i" ]; then
#			echo "$1 is folder"
#		else
#			continue
#		fi
#	done
#fi

if [ -d "$upperdir" -a -d "$workdir" -a -d "$union" ]; then
	mount -t overlay -o lowerdir="$lowerdir",upperdir="$upperdir",workdir="$workdir" overlay "$union"
	echo "$lowerdir is lowerdir, $upperdir is upperdir, $workdir is workdir, $union is the union"
fi

#for i in dev sys proc; do mount -o bind /$i chroot-union/$i; done

