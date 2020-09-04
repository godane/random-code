#!/bin/bash

y="2017"
for m in $(seq -w 01 09); do
	for d in $(seq -w 01 31); do
	iss="GSS_GSS"
	url="https://epub.stripes.com/docs/${iss}_${d}${m}${y:2:4}/${iss}_${d}${m}${y:2:4}.pdf"
	wget -c $url
	done
done
