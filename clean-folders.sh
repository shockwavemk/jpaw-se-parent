#!/bin/sh
# clean all source files related to:
# - tabs to spaces (indent level 4)
# - remove MSDOS / MS Windows carriage returns (eol style lf)
# - remove trailing spaces
# - add missing line feeds at end of file
# - remove trailing blank lines
# the order of these operations is important
#
# also create an updated /tmp/gitattributes file which reflects the file extensions processed in this script

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

echo "* text=auto" > /tmp/gitattributes

for ext in   xml MF   java xtend   bon bddl aes ned   jrxml properties   txt csv dump sql   html css dsp zul   sh   c h cpp   md tex
do
    echo "Cleanup: processing $ext"
    for folder in "$@"
    do
        echo "    $folder"
        for file in `find "$folder" -type f -name "*.$ext"`
        do
            # tabs to spaces and remove trailing spaces. See http://stackoverflow.com/questions/7359527/removing-trailing-starting-newlines-with-sed-awk-tr-and-friends
            expand -t 4 < "$file" | tr -d '\r' | sed 's/[ ]*$//g' | sed -e '$a\' | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' > untab-tmp$$ && mv untab-tmp$$ "$file"
        done
    done
    # add extension to updated .gitattributes
    echo "*.$ext text eol=lf" >> /tmp/gitattributes
done

IFS=$SAVEIFS
