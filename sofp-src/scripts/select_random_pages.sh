#!/usr/bin/env bash
file="$1"

pages="$2"

target="$3"

# This requires pdftk to be installed on the path. Edit the next line as needed.
pdftk=`which pdftk`

if [ x"$target" == x ] ; then

echo Usage: select_random_pages.sh file.pdf total_pages target_file.pdf

exit 1

fi


function pdfPages {
 local file="$1"
 "$pdftk" "$file" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'
}

totalpages=`pdfPages "$file"`

echo "INFO: selecting $pages out of total $totalpages pages"

epochtime=$(date -j -f "%a %b %d %T %Z %Y" "$(date)" "+%s")

randcommand="calc x=srand($epochtime);  "
for a in `seq 1 $pages`; do randcommand="$randcommand print rand(1,$totalpages); "; done

r=${TMPDIR:-/tmp}/random-page-delete-this

$randcommand | tail -n +1 | while read page; do
	echo Extracting page $page; "$pdftk" "$file" cat $page output "$r"-page$page.pdf
done

"$pdftk" "$r"-page*.pdf cat output $target; rm "$r"-page*.pdf

open $target

# To split into pages:
# gm convert 'document.pdf[12-45]' +adjoin output-%03d.png
