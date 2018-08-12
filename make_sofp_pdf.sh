#!/bin/bash

# Make a PDF package with embedded source archive.

# This requires pdftk to be installed on the path. Edit the next line as needed.
pdftk=`which pdftk`

# LyX needs to be installed for this to work. Edit the next line as needed.
lyx="/Applications/LyX.app/Contents/MacOS/lyx"

echo "Info: Using pdftk as '$pdftk' and lyx as '$lyx'"

name="sofp"

s="$name.lyx"
t="$name.tex"
p="$name.pdf"
z="$name-src.tar.bz2"

"$lyx" --export pdf2 $s
mv "$p" "1$p"
"$lyx" --export latex "$s"
tar jcvf "$z" "$s" "$t" "$0"
"$pdftk" "1$p" attach_files "$z" output "$p"
rm "1$p"
