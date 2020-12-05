#!/bin/bash

y="2020"
for m in 11; do
	for d in $(seq -w 01 31); do
		for h in $(seq -w 00 23); do
			for station in cknwam chmlam; do
			[ -d $station ] || mkdir -p $station
			url="https://electiondata.globalnews.ca/fm-playlist/audio/${station}/${y}.${m}.${d}-${h}.00.00.mp3"
			wget -c $url -P $station
			done
		done
	done
done
