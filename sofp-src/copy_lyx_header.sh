#!/bin/bash

# Get the lyx header from sofp.lyx and insert it into all sofp-* sub-documents, overwriting their headers.

function find_header {
	local f="$1"
	local header1=`fgrep -a -n '\begin_header' "$f" | cut -d: -f1`
	local header2=`fgrep -a -n '\end_header' "$f" | cut -d: -f1`
	echo $header1 $header2
}

headerfile=/tmp/header$$.tmp

find_header sofp.lyx | (
  read h1 h2
  # Copy the master header into a temporary file.
  # Replace '\inputencoding utf8' by '\inputencoding auto'; remove Chinese characters after '\newcommand{\shui}'.
  head -$h2 sofp.lyx | tail -n +$h1 \
   | sed -e 's|\inputencoding utf8|\inputencoding auto|; ' \
   | fgrep -v '\newcommand{\shui}' \
   | fgrep -v '\usepackage{CJKutf8}' > $headerfile
  # Insert '\master sofp.lyx' after '\use_default_options true'.
  h3=`fgrep -a -n '\use_default_options' $headerfile | cut -d: -f1`
  cat <(head -$h3 $headerfile) <(echo '\master sofp.lyx') <(tail -n +$((h3+1)) $headerfile) > $headerfile.1
  mv $headerfile.1 $headerfile
)

# For each sub-document, overwrite the header.
for s in sofp-*.lyx; do

find_header "$s" | (
  read h1 h2
  cat <(head -$((h1-1)) "$s") $headerfile <(tail -n +$((h2+1)) "$s") > "$s".1
  mv "$s".1 "$s"
)

done

rm -f "$headerfile"

