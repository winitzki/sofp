#!/bin/bash

# Requires pdftk and lyx.
# Get lyx from www.lyx.org
# For Mac, get pdftk from https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg

name="sofp"

draft="$name-draft"
srcbase="sofp-src"

export GS_OPTIONS="-dEmbedAllFonts=true -dPDFSETTINGS=/printer"

# Set custom lyx directory if needed.
if [ x"$LYXDIR" == x ]; then
	lyxdir=""
else
	lyxdir="-userdir $LYXDIR"
fi

test -d $srcbase && cd $srcbase

function git_commit_hash {
	git rev-parse HEAD # Do not use --short here.
}

function source_hash {
	cat $0 $name*.lyx | shasum -a 256 | cut -c 1-64
}

# Make a PDF package with embedded source archive.

function run_latex_many_times {
	local base="$1"
	echo "LaTeX Warning - Rerun" > "$base.log"
	while grep -q '\(LaTeX Warning.*Rerun\|^(rerunfilecheck).*Rerun\)' "$base.log"; do
		 latex --interaction=batchmode "$base.tex"
        done # This used to be only pdflatex but now we are using ps2pdf because of pstricks.
}

# Not used now, since we are using pdflatex.
function make_pdf_with_index_via_ps2pdf {
	local base="$1" fast="$2"
	if [[ -z "$fast" ]]; then
		run_latex_many_times "$base"
		makeindex "$base.idx"
	fi
	run_latex_many_times "$base"
        (dvips "$base.dvi" >& $base.log1; cat $base.log1 >> $base.log; rm $base.log1) >& /dev/null
        (ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true "$base.ps") 2>&1 >> $base.log
}

function make_pdf_with_index {
	local base="$1" fast="$2"
	if [ x"$fast" == x ]; then
		pdflatex --interaction=batchmode "$base"
		makeindex "$base.idx"
	fi
	pdflatex --interaction=batchmode "$base"
}

function add_color {
	local texsrc="$1"
	# Insert color comments into displayed equation arrays. Also, in some places the green color was inserted; replace by `greenunder`.
	# Example of inserted color: {\color{greenunder}\text{outer-interchange law for }M:}\quad &
	LC_ALL=C sed -i.bak -e 's|\\color{green}|\\color{greenunder}|; s|^\(.*\\text{[^}]*}.*:\)\( *\\quad \& \)|{\\color{greenunder}\1}\2|' "$texsrc"
	# Insert color background into all displayed equations. This is disabled because it does not always produce visually good results.
	if false; then
	LC_ALL=C sed -i.bak -E -e ' s!\\begin\{(align.?|equation)\}!\\begin{empheq}[box=\\mymathbgbox]{\1}!; s!\\end\{(align.?|equation)\}!\\end{empheq}!; ' "$texsrc"
	LC_ALL=C sed -i.bak -E -e ' s!^\\\[$!\\begin{empheq}[box=\\mymathbgbox]{equation*}!; s!^\\\]$!\\end{empheq}!; ' "$texsrc"
	fi
}

function add_source_hashes {
	gitcommit=`git_commit_hash`
	sourcehash=`source_hash`
	echo $sourcehash > $name.source_hash1
	LC_ALL=C sed -i.bak -E -e "s/INSERTSOURCEHASH/$sourcehash/; s/INSERTGITCOMMIT/$gitcommit/" $name.tex
	mv $name.source_hash1 $name.source_hash
}

function insert_examples_exercises_count { # This is replaced in the root file only.
	local base="$1" target="$2"
	local exercises=`cat "$base"-*.tex | LC_ALL=C fgrep -c '\subsubsection{Exercise '`
	local examples=`cat "$base"-*.tex | LC_ALL=C fgrep -c '\subsubsection{Example '`
	local codesnippets=`cat "$base"-*.tex | LC_ALL=C fgrep -c '\begin{lstlisting}'`
	local stmts=`cat "$base"-*.tex | LC_ALL=C fgrep -c '\subsubsection{Statement '`
	local diagrams=`cat "$base"-*.tex | LC_ALL=C fgrep -c '\xymatrix{'`
	local bdate=`date -R`
	local osinfo=`uname -rs`
	local pdftex=`pdflatex --version | fgrep pdfTeX\ 3.14`
	LC_ALL=C sed -i.bak -e "s|PDFTEXVERSION|$pdftex|g;  s|BUILDDATE|$bdate|g; s|BUILDOPERATINGSYSTEM|$osinfo|g; s,NUMBEROFEXAMPLES,$examples,g; s,NUMBEROFEXERCISES,$exercises,g; s,NUMBEROFDIAGRAMS,$diagrams,g; s,NUMBEROFSTATEMENTS,$stmts,g; s,NUMBEROFCODESNIPPETS,$codesnippets,g;" "$target"
}

function remove_lulu {
	local base="$1"
        LC_ALL=C sed -i.bak -e 's,^\(.publishers{Published by\),%\1,; s,^\(Published by\),%\1,; s,^\(ISBN:\),%\1,' "$base".tex
}

function add_lulu {
	local base="$1"
        LC_ALL=C sed -i.bak -e 's,^%\(.publishers{Published by \),\1,; s,^%\(Published by \),\1,; s,^%\(ISBN:\),\1,' "$base".tex
}

function assemble_sources {
	rm -rf "$srcbase"
	mkdir "$srcbase"
	# Copy the required source files to "$srcbase"/. Include graphics files referenced as images.
	cp ../README.md excluded_words $name*lyx $name*tex $name*dvi `grep -o 'includegraphics[^}]*}' $name*tex | sed -e 's,[^{]*{\([^}]*\)}.*,\1.*,' |while read f; do ls $f ; done` *.sh "$srcbase"/
	tar jcf "$name-src.tar.bz2" "$srcbase"/*
	rm -rf "$srcbase"/
}

# This requires pdftk to be installed on the path. Edit the next line as needed.
pdftk=`which pdftk`

# LyX needs to be installed for this to work. Edit the next line as needed.
lyx=`which lyx`

echo "Info: Using pdftk from '$pdftk' and lyx from '$lyx', lyx directory $lyxdir"

rm -f $name*tex $name*log $name*ilg $name*idx $name*toc

echo "Exporting LyX files $name.lyx and its child documents into LaTeX..."
"$lyx" $lyxdir -f all --export pdflatex $name.lyx # Exports LaTeX for all child documents as well.

# Preparing source files for the book cover.
cp book_cover/sofp-cover-page-no-bg.tex .
cp book_cover/sofp-cover-page.tex .

#### The LaTeX files are heavily post-processed after exporting from LyX.

echo "Post-processing LaTeX files..."

# Insert the number of examples and exercises. This replacement is only for the root file.
insert_examples_exercises_count $name $name.tex

## Remove mathpazo. This was a mistake: should not remove it.
#LC_ALL=C sed -i.bak -e 's/^.*usepackage.*mathpazo.*$//' $name.tex

# Replace ugly Palatino quote marks and apostrophes by sans-serif marks.
LC_ALL=C sed -i.bak -e " s|'s|\\\\textsf{'}s|g; s|O'|O\\\\textsf{'}|g; s|s'|s\\\\textsf{'}|g; "' s|``|\\textsf{``}|g; s|“|\\textsf{``}|g; '" s|''|\\\\textsf{''}|g; s|”|\\\\textsf{''}|g;  s|\\\\textsf{'}'|\\\\textsf{''}|g; " $name*.tex

# Add color to equation displays.
for f in $name*tex; do add_color "$f"; done

# Export Scala code snippets.
for f in $name-*tex; do g=`basename "$f" .tex`; cat $g.pre.md <(perl extract_scala_snippets.pl < $f) > ../mdoc/$g.md; done

# Remove control annotations for Scala code snippets.
LC_ALL=C sed -i.bak -e " s| +//IGNORETHIS.*||" $name*.tex

# Check whether the sources have changed. If so, create a new sources archive and a new PDF file.
add_source_hashes $name.tex
assemble_sources &
echo "Creating a full PDF file..."
make_pdf_with_index "$name" # Output is $name.pdf, main file is $name.tex, and other .tex files are \include'd.
wait
# Do not attach sources to the main PDF file.
#"$pdftk" "$name.pdf" attach_files "$name-src.tar.bz2" output "1$name.pdf"
#mv "1$name.pdf" "$name.pdf"
# Cleanup.
( tar jcf "$name-logs.tar.bz2" $name*log $name*ilg $name*idx $name*toc
  echo "Log files are found in $name-logs.tar.bz2"
) &

function kbSize {
 local file="$1"
 ls -l -n "$file"|sed -e 's/  */ /g'|cut -f5 -d ' '
}

function pdfPages {
 local file="$1"
 "$pdftk" "$file" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'
}

total_pages=`pdfPages "$name".pdf`

echo Result is "$name.pdf", size `kbSize "$name.pdf"` bytes, with $total_pages pages.

# Create the lulu.com draft file by selecting the chapters that have been proofread.
# Check page counts in the draft file and in individual chapters.
bash check_and_make_draft.sh
bash check-consistent-labels.sh
bash check-lines_with_displaymath_in_new_paragraph.sh

# Attach sources to the draft file.
if test -s $name-src.tar.bz2 && test -s $draft.pdf; then  "$pdftk" $draft.pdf attach_files "$name-src.tar.bz2" output $draft-src.pdf
else
	echo Not attaching sources to draft since no source file $name-src.tar.bz2 is found or no $draft.pdf is found.
fi
if [ x"$1" == x-nolulu ]; then
# Create a pdf file without references to lulu.com and without lulu.com's ISBN.
mv "$name".pdf "$name"-lulu.pdf
remove_lulu $name
make_pdf_with_index "$name" fast
create_draft $name $draft-nolulu.pdf

# The main file "$name".pdf has lulu.com information.
mv "$name"-lulu.pdf "$name".pdf

fi

if [ x"$1" == x-print ]; then
# Create a full pdf without hyperlinks, for printing on paper. Remove the cover image from first page.
mv "$name.pdf" "$name-hyperlinks.pdf"
LC_ALL=C sed -i.bak -e 's|colorlinks=true|colorlinks=false|; s|\\input{sofp-cover-page}||; ' $name.tex 
make_pdf_with_index $name fast
mv "$name.pdf" "$name-nohyperlinks.pdf"
mv "$name-hyperlinks.pdf" "$name.pdf"
fi

bash spelling_check.sh

# Prepare book covers.
for f in sofp-back-cover sofp-cover-parameters; do cp book_cover/$f.tex.src book_cover/$f.tex; done
insert_examples_exercises_count $name book_cover/sofp-back-cover.tex
sed -i.bak -e "s|TOTALPAGES|$total_pages|" book_cover/sofp-cover-parameters.tex
(cd book_cover; bash sofp-make-cover.sh)

# Cleanup?
#rm -f $name*{idx,ind,aux,dvi,ilg,out,toc,log,ps,lof,lot,data}
