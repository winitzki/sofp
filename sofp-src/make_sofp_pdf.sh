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
        (dvips "$base.dvi") 2>&1 >> $base.log
        (ps2pdf "$base.ps") 2>&1 >> $base.log
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
draft="$name-draft"
rm -f $name*tex

"$lyx" --export pdflatex $name.lyx # Exports LaTeX for all child documents as well.
for f in $name*tex; do add_color "$f"; done
make_pdf_with_index "$name" # Output is $name.pdf, main file is $name.tex, and other .tex files are \include'd.

srcbase="sofp-src"
rm -rf "$srcbase"
mkdir "$srcbase"
# Copy the required source files to "$srcbase"/.
cp ../README.md $name*lyx $name*tex $name*dvi `fgrep includegraphics $name*tex | sed -e 's,[^{]*{\([^}]*\)}.*,\1.*,' |while read f; do ls $f ; done` *.sh "$srcbase"/
tar jcvf "$name-src.tar.bz2" "$srcbase"/
rm -rf "$srcbase"/

function kbSize {
 local file="$1"
 ls -l -n "$file"|sed -e 's/  */ /g'|cut -f5 -d ' '
}

function pdfPages {
 local file="$1"
 pdftk "$file" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'
}

"$pdftk" "$name.pdf" attach_files "$name-src.tar.bz2" output "1$name.pdf"
mv "1$name.pdf" "$name.pdf"
echo Result is "$name.pdf", size `kbSize "$name.pdf"` bytes, with `pdfPages "$name.pdf"` pages.
# Cleanup.
tar jcvf "$name-logs.tar.bz2" $name*log $name*ilg $name*idx $name*toc
echo "Log files are found in $name-logs.tar.bz2"

# Create draft file.
pdftk $name.pdf dump_data output $name.data
egrep -v 'Bookmark(Level|Begin)' $name.data|fgrep Bookmark|perl -e 'undef $/; while(<>){ s/\nBookmarkPageNumber/ BookmarkPageNumber/ig; print; }' | \
   egrep '(Type-level functions|Applied functional type theory|C The Curry-Howard |E A humorous disclaimer)' | egrep -o '[0-9]+$' | \
   (read b1; read e1; read b2; read e2; pdftk sofp.pdf cat 1-$((b1-1)) $e1-$((b2-1)) $e2-end output $draft.pdf; echo Draft page ranges 1-$((b1-1)) $e1-$((b2-1)) $e2-end )
rm -f $name*{idx,ind,aux,dvi,ilg,out,toc,log,ps,lof,lot,data}

pdftk $draft.pdf attach_files "$name-src.tar.bz2" output 1$draft.pdf
mv 1$draft.pdf $draft.pdf
echo Draft file created as $draft.pdf, size `kbSize $draft.pdf` bytes, with `pdfPages $draft.pdf` pages.

