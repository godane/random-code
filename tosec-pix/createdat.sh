#!/bin/bash

name="$(echo "$1" | sed 's|/| - |g')"
version="2020-09-14"
desc="$(echo "$name (TOSEC-v${version}"))"
category="TOSEC-PIX"
author="TOSEC-PIX"
email="contact@tosecdev.org"
url="http://www.tosecdev.org/"

outputdat="output.dat"
echo "<?xml version="1.0" encoding="UTF-8"?>" >> $outputdat
echo "<!DOCTYPE datafile PUBLIC "-//Logiqx//DTD ROM Management Datafile//EN" "http://www.logiqx.com/Dats/datafile.dtd">" >> $outputdat
echo "" >> $outputdat

echo "<datafile>" >> $outputdat
echo -e "\t<header>" >> $outputdat
echo -e "\t\t<name>${name}</name>" >> $outputdat
echo -e "\t\t<description>${desc}</description>" >> $outputdat
echo -e "\t\t<category>${category}</category>" >> $outputdat
echo -e "\t\t<version>${version}</version>" >> $outputdat
echo -e "\t\t<author>${author}</author>" >> $outputdat
echo -e "\t\t<email>${email}</email>" >> $outputdat
echo -e "\t\t<homepage>TOSEC</homepage>" >> $outputdat
echo -e "\t\t<url>${url}</url>" >> $outputdat
echo -e "\t</header>" >> $outputdat

ext="pdf"
find "$1" -maxdepth 1 -name "*.${ext}" -type f | sort | while read file; do
	name="$(basename "$file" .${ext})"
	crc="$(crc32 "$file")"
	sha1="$(sha1sum "$file" | sed 's| .*||g')"
	md5="$(md5sum "$file" | sed 's| .*||g')"
	size="$(du -b "$file" | cut -f1)"
	echo -e "\t<game name=\"${name}\">" >> $outputdat
	echo -e "\t\t<description>${name}</description>" >> $outputdat
	echo -e "\t\t<rom name="$(basename "$file")" size=\"${size}\" crc=\"${crc}\" md5=\"${md5}\" sha1=\"${sha1}\"/>" >> $outputdat
	echo -e "\t</game>" >> $outputdat
done
echo "</datafile>" >> $outputdat




