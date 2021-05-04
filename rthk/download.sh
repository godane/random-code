#!/bin/bash


for y in 2017; do
for m in $(seq -w 01 31); do
for d in $(seq -w 01 31); do
url="http://stmw.rthk.hk/aod/_definst_/radio/archive/radio1/hktoday/mp3/mp3:${y}${m}${d}.mp3/playlist.m3u8"
[ -f ${y}${m}${d}.mp3 ] || youtube-dl $url -o ${y}${m}${d}.mp3
done
done
done
