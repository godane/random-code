#!/bin/bash

y="2025"
endy="$(echo "${y} + 1" | bc)"
#url="https://www.cia.gov/readingroom/search/site?f%5B0%5D=dm_field_release_date%3A%5B${y}-01-01T00%3A00%3A00Z%20TO%20${endy}-01-01T00%3A00%3A00Z%5D"
url="https://www.cia.gov/readingroom/search/site/?f%5B0%5D=ds_created%3A%5B${y}-01-01T00%3A00%3A00Z%20TO%20${endy}-01-01T00%3A00%3A00Z%5D"
#url="https://www.cia.gov/readingroom/advanced-search-view?keyword=&im_field_collection%5B%5D=1&label=&sm_field_document_number=&sm_field_original_classification=&ds_field_pub_date_op=%3D&ds_field_pub_date%5Bvalue%5D=&ds_field_pub_date%5Bmin%5D=&ds_field_pub_date%5Bmax%5D=&sm_field_content_type=&sm_field_case_number="
useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

#[ -f index.html ] || wget --user-agent="$useragent" -c $url -O index.html
chromium --headless --disable-web-security=false --user-data-dir=chrome-data --dump-dom  --user-agent="$useragent" $url > index.html

#cat index.html | grep href= | sed 's|.*href="||g' | sed 's|".*||g' | grep ^http | grep readingroom/document | sed 's|.*/||g' > list.txt
cat index.html | grep readingroom/document | sed 's|.*href="||g' | sed 's|".*||g' | sed 's|.*/||g' > list.txt


end="164"
for p in $(seq 1 $end); do
	purl="https://www.cia.gov/readingroom/search/site?page=${p}&f%5B0%5D=ds_created%3A%5B${y}-01-01T00%3A00%3A00Z%20TO%20${endy}-01-01T00%3A00%3A00Z%5D"
	#purl="https://www.cia.gov/readingroom/advanced-search-view?keyword=&im_field_collection%5B0%5D=1&label=&sm_field_document_number=&sm_field_original_classification=&ds_field_pub_date_op=%3D&ds_field_pub_date%5Bvalue%5D=&ds_field_pub_date%5Bmin%5D=&ds_field_pub_date%5Bmax%5D=&sm_field_content_type=&sm_field_case_number=&page=${p}"
	index="index${p}.html"
	echo "downloading page $p"
	sleep 2
	#wget --user-agent="$useragent" -c $purl -O $index
	chromium --headless --disable-web-security=false --user-data-dir=chrome-data --dump-dom  --user-agent="$useragent" $purl > $index
	#cat $index | grep href= | sed 's|.*href="||g' | sed 's|".*||g' | grep ^http | grep readingroom/document | sed 's|.*/||g' >> list.txt
	cat $index | grep readingroom/document | sed 's|.*href="||g' | sed 's|".*||g' | sed 's|.*/||g' >> list.txt
done
