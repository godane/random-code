#!/bin/bash

k="151"
start="000"
end="999"
for i in $(seq ${k}${start} ${k}${end}); do

dir="${k}${start}-to-${k}${end}"
[ -d $dir/$i ] || mkdir -p $dir/$i

wget --content-disposition https://www.fda.gov/media/${i}/download -P $dir/$i
done

