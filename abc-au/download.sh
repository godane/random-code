#!/bin/bash


for y 2018; do
for m in $(seq -w 01 12); do
for d in $(seq -w 01 31); do
url="https://abcmedia.akamaized.net/radio/local_sydney/audio/${y}${m}/pam-${y}-${m}-${d}.mp3"
file="$(basename $url)"
[ -f $file ] || wget -c $url
done
done
done

