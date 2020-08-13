#!/bin/sh

#k="780"
for k in 1050; do #$(seq 920 929); do
#order="$(seq -w ${k}000 ${k}999)"
order="${k}000"
bucket="x-amz-auto-make-bucket:1"
#bucket="x-archive-ignore-preexisting-bucket:1"
#type="ADA"
check="yes"
if [ "$(echo ${k} | wc -c)" == "5" ]; then
    ad0="AD"
else
    ad0="AD0"
fi

for i in $order; do
for type in $ad0 ADA ADB ADC ADP; do

	b="$type"

	id="DTIC_${b}${i}"
	domain="apps.dtic.mil"
	if [ "$type" = "ADA" ]; then
		type1="a"
	elif [ "$type" = "ADB" ]; then
		type1="b"
		#findfile="$(find $domain/dtic/tr/fulltext/u2 -size +19k -type f -name "b${i}.pdf")"
	elif [ "$type" = "ADC" ]; then
		type1="c"
		#findfile="$(find $domain/dtic/tr/fulltext/u2 -size +19k -type f -name "c${i}.pdf")"
	elif [ "$type" = "ADP" ]; then
		type1="p"
		#findfile="$(find $domain/dtic/tr/fulltext/u2 -size +19k -type f -name "p${i}.pdf")"
	else
		type1=""
		#findfile="$(find $domain/dtic/tr/fulltext/u2 -size +19k -type f -name "${i}.pdf")"
	fi
	#echo "${type1}${i}.pdf"


	if [ "$check" == "yes" ]; then
		url="archive.org/download/$id"
		[ -f "$url" ] || wget -x -c $url
		if [ -f "$url" ]; then
			if [ "$(grep "$(basename "$file")" $url)" != "" ]; then
				echo "$file is in $url"
				continue
			fi
		fi
	fi

	domain="apps.dtic.mil"
	#domain="131.84.180.30"
	path="$domain/dtic/tr/fulltext/u2"
	[ -d $path ] || mkdir -p $path
	wget -x -U firefox --no-check-certificate -T 5 -c https://${path}/${type1}${i}.pdf

	findfile="$(find $domain/dtic/tr/fulltext/u2 -size +19k -type f -name "${type1}${i}.pdf")"
	file="$findfile"
	[ -f "$file" ] || continue

	#anum="$(curl -s http://www.dtic.mil/docs/citations/${b}${i} | grep 'Accession Number : ' | sed 's|.*</b>||g' | sed 's|</p>||g')"

	title1="$(curl -A Firefox -s https://$domain/docs/citations/${b}${i} | grep '<title>' | sed 's|<title>||g' | sed 's|</title>||g')"
	title="DTIC ${b}${i}: $title1"
	desc="$(curl -A Firefox -s https://$domain/docs/citations/${b}${i} | grep 'Abstract' | tail -1 | sed 's|.* : </b>||g' | sed 's|</p>||g')"

	creator="$(curl -A Firefox -s https://$domain/docs/citations/${b}${i} | grep 'Author(s) :' | sed 's|.* : </b>||g' | sed 's|  ;   |; |g' | sed 's|</p>||g')"
	cauthor="$(curl -A Firefox -s https://$domain/docs/citations/${b}${i} | grep 'Corporate Author : ' | sed 's|.*</b>||g' | sed 's|</p>||g')"
	keywords="$(curl -A Firefox -s https://$domain/docs/citations/${b}${i} | grep 'citation_keywords' | sed 's|.*content="||g' | sed 's|">||g' | sed 's|, |; |g')"
	basekeywords="DTIC Archive; ${creator}; ${cauthor}; ${keywords};"
	date1="$(curl -A Firefox -s https://$domain/docs/citations/${b}${i} | grep 'citation_date' | sed 's|.*content="||g' | sed 's|">||g')"
	if [ "$(echo "${date1}" | grep ^[A-Z])" != "" ]; then
		date2="$(echo 1 "$date1")"
		date="$(date -d "$date2" +%Y-%m-%d)"
	elif [ "$(echo "${date1}" | grep ^[0-9][0-9][0-9][0-9])" != "" ]; then
		date2="$(echo "1 JAN $date1")"
		date="$(date -d "$date2" +%Y-%m-%d)"
	else
		date="$(date -d "$date1" +%Y-%m-%d)"
	fi
	
	ia upload $id "$file" -H "x-archive-check-file:0" \
		--metadata="collection:godaneinbox" \
		--metadata="mediatype:texts" \
		--metadata="creator:Defense Technical Information Center" \
		--metadata="language:english" \
		--metadata="date:$date" \
		--metadata="title:$title" \
		--metadata="subject:${basekeywords}" \
		--metadata="description:$desc"
done
done
done
