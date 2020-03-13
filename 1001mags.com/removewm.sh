#!/bin/bash

manual="y"
path="tmp"
ls $path/*.pdf | while read file; do
basefile="$(basename "$file" .pdf)"
decrypt="$path/${basefile}-decrypt.pdf"
exiftool -e -all:all="" "$path/${basefile}.pdf"
qpdf --linearize --decrypt "$path/${basefile}.pdf" "$path/${basefile}-decrypt.pdf"
fixed="$path/${basefile}-fixed.pdf"
uncompressed="$path/${basefile}-uncompressed.pdf"
unwatermarked="$path/${basefile}-unwatermarked.pdf"
unwatermarkedfix="$path/${basefile}-unwatermarked-fix.pdf"
compressed="$path/${basefile}-compressed.pdf"
end="$path/${basefile}-2end.pdf"
cover="$path/${basefile}-cover.pdf"
#echo "creating $fixed"
#pdftk "$file" output "$fixed"
echo "creating $uncompressed"
pdftk "$decrypt" output "$uncompressed" uncompress
echo "creating $cover"
pdftk "$uncompressed" cat 1 output "$cover"
pdftk "$uncompressed" cat 2-end output "${end}"
cat "$cover" | sed "/Length 3[6-7][0-9]$/,/Length 768$/d" >"$unwatermarked"
#cat "$cover" | sed "/Exemplaire strictement personnel/,/gmail.com/d" | sed 's|^1 0 0 1 ||g' > "$unwatermarked"
#cat "$cover" | sed "/Exemplaire strictement personnel/,/gmail.com/d" > "$unwatermarked"
#cat "$cover" | sed "/Length 300$/,/endstream/d" > "$unwatermarked"

echo "creating $unwatermarkedfix"
pdftk "$unwatermarked" output "$unwatermarkedfix"
echo "creating $fixed"
pdfunite "$unwatermarkedfix" "${end}" "${fixed}"


#sed "s/slaxemulator@gmail.com/ /g" "$uncompressed" > "$unwatermarked"
echo "creating $compressed"
[ -f "$compressed" ] || pdftk "$fixed" output "$compressed" compress
if [ "$manual" == "" ]; then
if [ -f "$fixed" ]; then
	rm "$fixed"
fi
if [ -f "$uncompressed" ]; then
	rm "$uncompressed"
fi
if [ -f "$unwatermarked" ]; then
	rm "$unwatermarked"
fi
if [ -f "$end" ]; then
	rm "$end"
fi
if [ -f "$cover" ]; then
	rm "$cover"
fi
if [ -f "$decrypt" ]; then
	rm "$decrypt"
fi
if [ -f "$unwatermarkedfix" ]; then
	rm "$unwatermarkedfix"
fi
if [ -f "$compressed" ]; then
	mv -f "$compressed" "$file"
fi
fi
done
