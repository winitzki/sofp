#!/bin/bash

pdftk=$1

dir=12pt

rm -rf $dir
mkdir -p $dir/book_cover
cd $dir

tar jxf ../sofp-src.tar.bz2
mv sofp-src/* .

cp ../sofp*.tex ../sofp.* .
cp ../book_cover/* ./book_cover/

cp book_cover/* .

cp book_cover/sofp-cover-parameters.tex.src book_cover/sofp-cover-parameters.tex

# Set 10pt font.
LC_ALL=C sed -i.bak -e 's|fontsize=12pt|fontsize=10pt|' sofp.tex


pdflatex --interaction=batchmode sofp
makeindex sofp.idx

pdflatex --interaction=batchmode sofp

mv sofp.pdf ../sofp-10pt.pdf
