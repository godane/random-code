#!/bin/bash


ver="slackware-1.01"
rsync -havP \
	--delete --delete-after \
	--no-o --no-g --safe-links \
	--timeout=60 --contimeout=30 \
	rsync://slackware.uk/slackware/${ver}/ \
	${ver}/
