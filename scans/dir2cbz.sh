#!/bin/bash

find -maxdepth 1 -type d | sort | sed 's|./||g' | sed 's|^.$||g' | while read dir; do
	if [ -d "${dir}" ]; then
		zip -r "${dir}.cbz" "${dir}"
	fi
done
