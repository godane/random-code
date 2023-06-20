#!/bin/bash

y="1977"
endy="$(echo "${y} + 1" | bc)"
url="https://www.cia.gov/readingroom/search/site?page=1&f%5B0%5D=dm_field_release_date%3A%5B${y}-01-01T00%3A00%3A00Z%20TO%20${endy}-01-01T00%3A00%3A00Z%5D"

[ -f index.html ] || wget -c $url -O index.html
cat index.html | grep href= | sed 's|.*href="||g' | sed 's|".*||g' | grep ^http | grep readingroom/document | sed 's|.*/||g' > list.txt

end="2"
for p in $(seq 1 $end); do
	purl="https://www.cia.gov/readingroom/search/site?page=${p}&f%5B0%5D=dm_field_release_date%3A%5B${y}-01-01T00%3A00%3A00Z%20TO%20${endy}-01-01T00%3A00%3A00Z%5D"
	index="index${p}.html"
	echo "downloading page $p"
	wget -c $purl -O $index
	cat $index | grep href= | sed 's|.*href="||g' | sed 's|".*||g' | grep ^http | grep readingroom/document | sed 's|.*/||g' >> list.txt
done
