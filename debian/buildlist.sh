#!/bin/bash

# provides list of packages that have
# nothing depending on them

for target in `dpkg -l | grep '^ii' | awk '{ print \$2 }'`; do
   if [ "`apt-cache rdepends --installed $target | wc -l`" = "2" ]; then
      echo "$target" >> pkglist.txt
   fi
done
