#!/bin/bash

show="$1"
end="$end"
for i in $(seq -w 0001 $end); do
	url="http://twit.cachefly.net/audio/${show}/${show}${i}/${show}${i}.mp3"
	wget -c $url
done
