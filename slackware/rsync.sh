#!/bin/bash

for i in 1.01 1.1.2 1.2.0 2.0.0 2.0.1 2.1 2.2.0 2.3 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.9 4.0 7.0 7.1 8.0 9.0 9.1 10.0 10.1 10.2 11.0 12.0 12.1 12.2 13.0 13.1 13.37; do
ver="slackware-$i"
rsync -havP \
	--delete --delete-after \
	--no-o --no-g --safe-links \
	--timeout=60 --contimeout=30 \
	rsync://slackware.uk/slackware/${ver}/ \
	${ver}/

tar -cvf ${ver}.tar ${ver}
if [ -f "${ver}.tar" ]; then
    rm -rf ${ver}
fi
done
