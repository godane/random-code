#!/bin/bash

code="RNews"
pcode="RADR0125"
for i in $(seq 15900 15999); do
codeurl="$(curl -s "http://www.arirang.com/Player/Radio_AOD_2016.asp?code=${code}&Prog_Code=${pcode}&ACode=${i}" | grep kollus.com | sed 's|.*src="||g' | sed 's|" .*||g')"

url="$(curl -s $codeurl |  grep master.m3u8 | sed 's|.*media_url||g' | sed 's|\\||g' | sed 's|%3D|=|g' | sed 's|%2F|/|g' | sed 's|%2A|*|g' | sed 's|%7E|~|g' | sed 's|","poster.*||g' | sed 's|":"||g')"

youtube-dl $url -o $i.m4a

done

