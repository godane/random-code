#!/bin/bash

#curl -s https://www.lost-manuals.com/sitemap_downloads.xml | sed 's|><|>\n<|g' | grep '<loc>' | sed 's|.*<loc>||g' | sed 's|</loc>||g'

for i in $(cat list.txt); do
	[ -f $(basename $i) ] || wget -c $i --header="Cookie: PHPSESSID=6gtdjfnhbn46q1jc67oqunhva3"
done

