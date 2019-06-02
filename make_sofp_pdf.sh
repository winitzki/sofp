#!/bin/bash

# Make a PDF package with embedded source archive.

function run_latex_many_times {
	local base="$1"
	echo "LaTeX Warning - Rerun" > "$base.log"
	while grep -q '\(LaTeX Warning.*Rerun\|^(rerunfilecheck).*Rerun\)' "$base.log"; do pdflatex --interaction=batchmode "$base.tex"; done 
}

function make_pdf_with_index {
	local base="$1"
	run_latex_many_times "$base"
	makeindex "$base.idx"
	run_latex_many_times "$base"
}

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

if false; then
	"$lyx" --export pdf2 $s
	"$lyx" --export latex "$s"
	mv "$p" "1$p"

else
	"$lyx" --export pdflatex "$s"
# Example of inserted color: \scalebox{0.8}{\color{greenunder}\text{outer-identity}:}\quad &
	LC_ALL=C sed -e 's|^\(.*\\text{.*}.*:\)\( *\\quad \& \)|{\\color{greenunder}\1}\2|' < "$t" > "1$t"
	make_pdf_with_index "1$name"
	mv "1$t" "$t"
	tar jcvf "$z" "$s" "$t" *.jpg "$0"
	"$pdftk" "1$p" attach_files "$z" output "$p"
	rm "1$name".*

fi
