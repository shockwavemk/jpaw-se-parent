#!/bin/sh
# clean all source files related to:
# - tabs to spaces (indent level 4)
# - remove MSDOS / MS Windows carriage returns (eol style lf)
# - remove trailing spaces
# - add missing line feeds at end of file
# - remove trailing blank lines
# the order of these operations is important

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for file in "$@"
do
    # tabs to spaces and remove trailing spaces. See http://stackoverflow.com/questions/7359527/removing-trailing-starting-newlines-with-sed-awk-tr-and-friends
    expand -t 4 < "$file" | tr -d '\r' | sed 's/[ ]*$//g' | sed -e '$a\' | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' > untab-tmp$$ && mv untab-tmp$$ "$file"
done

IFS=$SAVEIFS
