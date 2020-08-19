#!/bin/bash


url="$1"
curl -s $url | grep pdf | sed 's|.*"../|central-manuals.com/|g' | sed 's|".*||g' | grep -v 'meta name=' > list.txt

for i in $(cat list.txt); do
	wget -c $i
done



#for part of the id name
#curl -s https://www.central-manuals.com/instructions_manual_user_guide_camcorder/aaton.php | grep pdf | grep -v "meta name=" | sed 's|.*download/||g' | sed 's|".*||g' | sed 's|/|_|g' | sed 's|(|_|g' | sed 's|)|_|g' | sed 's|\&|_|g' | sed "s|'|_|g" | sed 's|.pdf$||g'
