#!/bin/bash

# This script needs to run in the sofp-src/ subdirectory.

# Requires pdftk and lyx.
# Get lyx from www.lyx.org
# For Mac, get pdftk from https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg or else it may not work
# For Windows, get pdftk from https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_free-2.02-win-setup.exe

source scripts/functions.sh

# This requires pdftk to be installed on the path. Edit the next line as needed.
export pdftk=`which pdftk`

# LyX needs to be installed for this to work. Edit the next line as needed.
export lyx=`which lyx`


# Set custom lyx directory if needed.
if [ x"$LYXDIR" == x ]; then
	export lyxdir=""
else
	export lyxdir="-userdir $LYXDIR"
fi

echo "Info: Using pdftk from '$pdftk' and lyx from '$lyx', lyx directory $lyxdir"

export GS_OPTIONS="-dEmbedAllFonts=true -dPDFSETTINGS=/printer"

bash scripts/make_pdflatex_sources.sh

# Preparing source files for the book cover.

for f in  sofp-back-cover-no-bg sofp-cover-parameters; do cp book_cover/$f.tex.src book_cover/$f.tex; done
insert_examples_exercises_count $name book_cover/sofp-back-cover-no-bg.tex
for f in sofp-cover-page-no-bg.tex sofp-cover-page.tex sofp-back-cover.tex sofp-back-cover-page.tex sofp-back-cover-no-bg.tex cover-background.jpg cover-background-2.jpg monads_evil_face.jpg; do cp book_cover/"$f" .; done


# Prepare "$name-src.tar.bz2" with all sources.
assemble_sources &

echo "Creating a full PDF file..."

# Output is $name.pdf, main file is $name.tex, and other .tex files are \include'd.
make_pdf_with_index "$name" >& /dev/null

# Wait until assemble_sources is finished.
wait

	if ! test -s "$name".pdf; then
		echo Output file "$name".pdf not found, exiting.
		exit 1
	fi

function attach_sources_to_main_pdf {
  "$pdftk" "$name.pdf" attach_files "$name-src.tar.bz2" output "1$name.pdf"
  mv "1$name.pdf" "$name.pdf"
}

attach_sources_to_main_pdf

# Archive the build logs.
( tar jcf "$name-logs.tar.bz2" $name*log $name*ilg $name*idx $name*toc
  echo "Log files are found in $name-logs.tar.bz2"
) &


total_pages=`pdfPages "$name".pdf`

echo Result is "$name.pdf", size `kbSize "$name.pdf"` bytes, with $total_pages pages.

bash prepare_10point.sh "$pdftk" &

bash prepare_volume.sh 1 "$pdftk" &
bash prepare_volume.sh 2 "$pdftk" &
bash prepare_volume.sh 3 "$pdftk" &

bash spelling_check.sh &

# Create the "clean draft" pdf file by selecting the chapters that have been proofread.
# Check page counts in the draft file and in individual chapters.
#bash check_and_make_draft.sh
#draft_pages=`pdfPages "$draft".pdf`
bash check-consistent-labels.sh
bash check-lines_with_displaymath_in_new_paragraph.sh
bash check-punctuation-before-code-blocks.sh

if [ x"$1" == x-nolulu ]; then
	# Create a pdf file without references to lulu.com and without lulu.com's ISBN.
	mv "$name".pdf "$name"-lulu.pdf
	remove_lulu $name
	make_pdf_with_index "$name" fast >& /dev/null
	create_draft $name $draft-nolulu.pdf

	# The main file "$name".pdf has lulu.com information.
	mv "$name"-lulu.pdf "$name".pdf
fi

# Prepare an entire PDF file without hyperlinks.
#if [ x"$1" == x-print ]; then
#  bash remove_hyperlinks.sh $name
#fi


# Prepare the full 3-page book covers. Use $total_pages of the whole pdf file and not $draft_pages since the printed file has all unedited content as well.
bash prepare_cover.sh "$name.pdf" "$pdftk" &

# Cleanup?
#rm -f $name*{idx,ind,aux,dvi,ilg,out,toc,log,ps,lof,lot,data}

# Wait for background jobs.
wait
