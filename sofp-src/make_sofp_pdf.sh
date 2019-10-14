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
	local base="$1" fast="$2"
	if [[ -z "$fast" ]]; then
		run_latex_many_times "$base"
		makeindex "$base.idx"
	fi
	run_latex_many_times "$base"
        (dvips "$base.dvi") 2>&1 >> $base.log
        (ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true "$base.ps") 2>&1 >> $base.log
}

function add_color {
	local texsrc="$1"
	# Insert color comments into displayed equation arrays.
	# Example of inserted color: {\color{greenunder}\text{outer-interchange law for }M:}\quad &
	LC_ALL=C sed -i "" -e 's|^\(.*\\text{.*}.*:\)\( *\\quad \& \)|{\\color{greenunder}\1}\2|' "$texsrc"
	# Insert color background into all displayed equations.
	LC_ALL=C sed -i "" -E -e ' s!\\begin\{(align.?|equation)\}!\\begin{empheq}[box=\\mymathbgbox]{\1}!; s!\\end\{(align.?|equation)\}!\\end{empheq}!; ' "$texsrc"
	LC_ALL=C sed -i "" -E -e ' s!^\\\[$!\\begin{empheq}[box=\\mymathbgbox]{equation*}!; s!^\\\]$!\\end{empheq}!; ' "$texsrc"
}

function remove_lulu {
	local base="$1"
        LC_ALL=C sed -i "" -e 's,^\(.publishers{Published by\),%\1,; s,^\(Published by\),%\1,; s,^\(ISBN:\),%\1,' "$base".tex
}

function add_lulu {
	local base="$1"
        LC_ALL=C sed -i "" -e 's,^%\(.publishers{Published by \),\1,; s,^%\(Published by \),\1,; s,^%\(ISBN:\),\1,' "$base".tex
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
 "$pdftk" "$file" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'
}

# Do not attach sources to the main PDF file.
#"$pdftk" "$name.pdf" attach_files "$name-src.tar.bz2" output "1$name.pdf"
#mv "1$name.pdf" "$name.pdf"
echo Result is "$name.pdf", size `kbSize "$name.pdf"` bytes, with `pdfPages "$name.pdf"` pages.
# Cleanup.
tar jcvf "$name-logs.tar.bz2" $name*log $name*ilg $name*idx $name*toc
echo "Log files are found in $name-logs.tar.bz2"

function create_draft {
	local base="$1" output_pdf="$2"
	"$pdftk" $name.pdf dump_data output $name.data
	egrep -v 'Bookmark(Level|Begin)' $name.data|fgrep Bookmark|perl -e 'undef $/; while(<>){ s/\nBookmarkPageNumber/ BookmarkPageNumber/ig; print; }' | \
	egrep '(8 Computations in functor blocks. I. Filterable functors|Applied functional type theory|C The Curry-Howard |E A humorous disclaimer)' | egrep -o '[0-9]+$' | \
		(read b1; read e1; read b2; read e2; pdftk sofp.pdf cat 1-$((b1-1)) $e1-$((b2-1)) $e2-end output $output_pdf; echo Draft page ranges 1-$((b1-1)) $e1-$((b2-1)) $e2-end )

	echo Draft file created as $output_pdf, size `kbSize $output_pdf` bytes, with `pdfPages $output_pdf` pages.
	
}

# Create the lulu.com draft file by selecting the chapters that have been proofread.
create_draft $name $draft.pdf

# Attach sources to the draft file.
"$pdftk" $draft.pdf attach_files "$name-src.tar.bz2" output $draft-src.pdf

# Create a pdf file without references to lulu.com and without lulu.com's ISBN.
mv "$name".pdf "$name"-lulu.pdf
remove_lulu $name
make_pdf_with_index "$name" fast
create_draft $name $draft-nolulu.pdf

# The main file "$name".pdf has lulu.com information.
mv "$name"-lulu.pdf "$name".pdf

# Cleanup.
#rm -f $name*{idx,ind,aux,dvi,ilg,out,toc,log,ps,lof,lot,data}
