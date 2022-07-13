#!/bin/sh

#k="617"
for k in $1; do #$(seq 920 929); do
order="$(seq -w ${k}000 ${k}999)"
#order="${k}000"
bucket="x-amz-auto-make-bucket:1"
#bucket="x-archive-ignore-preexisting-bucket:1"
#type="ADA"
check="yes"

for i in $order; do
for type in ED; do

	b="$type"

	id="ERIC_${b}${i}"
	echo $id

	domain="eric.ed.gov"
	#domain="131.84.180.30"
	path="files.$domain/fulltext"
	[ -d $path ] || mkdir -p $path
	url="archive.org/download/$id"
	[ -f "$url" ] || wget -x -c $url
	if [ ! -f "$url" ]; then
		[ -f $path/${b}${i}.pdf ] || wget -x -U firefox --no-check-certificate -T 5 -c http://$path/${b}${i}.pdf
	fi
	findfile="$(find $path -size +19k -type f -name "${b}${i}.pdf")"
	file="$findfile"
	[ -f "$file" ] || continue

	if [ "$check" == "yes" ]; then
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "$file")" $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi



	title1="$(curl -A Firefox -s https://$domain/?id=${b}${i} | sed 's|><|>\n<|g' | grep 'div class' | grep title | sed 's|.*">||g' | sed 's|</div>||g')"
	title="ERIC ${b}${i}: $title1"
	desc="$(curl -s https://$domain/?id=${b}${i} | sed 's|><|>\n<|g' | grep abstract | grep 'div class' | sed 's|.*">||g' | sed 's|</div>||g')"

	creator="ERIC"
	keywords="$(curl -s https://$domain/?id=${b}${i} | sed 's|><|>\n<|g' | grep citation_keywords | sed 's|</a>||g' | sed 's|,|;|g' | sed 's|.*content="||g' | sed 's|".*||g')"
	cauthor="$(curl -s https://eric.ed.gov/?id=${b}${i} | sed 's|><|>\n<|g' | grep citation_author | sed 's|.*content="||g' | sed 's|".*||g')"

	basekeywords="ERIC Archive; ${creator}; ${cauthor}; ${keywords};"
	date="$(curl -s https://eric.ed.gov/?id=${b}${i} | sed 's|><|>\n<|g' | grep citation_publication_date | sed 's|.*content="||g' | sed 's|".*||g' | sed 's|/00||g' | sed 's|/|-|g')"

	
	ia upload $id "$file" -H "x-archive-check-file:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="creator:$creator" \
		--metadata="language:english" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}" \
		--metadata="description:$desc"
done
done
done
