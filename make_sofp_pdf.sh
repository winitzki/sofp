#!/bin/bash

# Make a PDF package with embedded source archive.

function run_latex_many_times {
	local base="$1"
	echo "LaTeX Warning - Rerun" > "$base.log"
	while grep -q '\(LaTeX Warning.*Rerun\|^(rerunfilecheck).*Rerun\)' "$base.log"; do
		 latex --interaction=batchmode "$base.tex"
        done # This used to be only pdflatex but now we are using ps2pdf because of pstricks.
}

function make_pdf_with_index {
	local base="$1"
	run_latex_many_times "$base"
	makeindex "$base.idx"
	run_latex_many_times "$base"
        dvips "$base.dvi" 2>&1 >> $base.log
        ps2pdf "$base.ps" >> $base.log
}

function add_color {
	local base="$1"
	# Insert color comments into displayed equation arrays.
	# Example of inserted color: {\color{greenunder}\text{outer-interchange law for }M:}\quad &
	LC_ALL=C sed -e 's|^\(.*\\text{.*}.*:\)\( *\\quad \& \)|{\\color{greenunder}\1}\2|' < "$base" > "1$base"
	mv "1$base" "$base"
}

# This requires pdftk to be installed on the path. Edit the next line as needed.
pdftk=`which pdftk`

# LyX needs to be installed for this to work. Edit the next line as needed.
lyx="/Applications/LyX.app/Contents/MacOS/lyx"

echo "Info: Using pdftk as '$pdftk' and lyx as '$lyx'"

name="sofp"

rm -f $name*tex

"$lyx" --export pdflatex $name.lyx # Exports LaTeX for all child documents as well.
for f in $name*tex; do add_color "$f"; done
make_pdf_with_index "$name" # Output is $name.pdf, main file is $name.tex, and other .tex files are \include'd.
tar jcvf "$name-src.tar.bz2" $name*lyx $name*tex $name*dvi `fgrep includegraphics $name*tex | sed -e 's,[^{]*{\([^}]*\)},\1.*,' |while read f; do ls $f ; done` "$0"
"$pdftk" "$name.pdf" attach_files "$name-src.tar.bz2" output "1$name.pdf"
mv "1$name.pdf" "$name.pdf"
echo Result is "$name.pdf" having `pdftk "$name.pdf" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'` pages.
# Cleanup.
tar jcvf "$name-logs.tar.bz2" $name*log $name*ilg $name*idx
echo "Log files are found in $name-logs.tar.bz2"
rm -f $name*{idx,ind,aux,dvi,ilg,out,toc,log,ps}
