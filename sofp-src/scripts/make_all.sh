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

rm -rf build mdoc tex

mkdir build mdoc

echo "Info: Using pdftk from '$pdftk' and lyx from '$lyx', lyx directory $lyxdir"

export GS_OPTIONS="-dEmbedAllFonts=true -dPDFSETTINGS=/printer"

bash scripts/make_pdflatex_sources.sh

# Preparing source files for the book cover.

#for f in  sofp-back-cover-no-bg sofp-cover-parameters; do cp book_cover/$f.tex.src book_cover/$f.tex; done
#
#for f in sofp-cover-page-no-bg.tex sofp-cover-page.tex sofp-back-cover.tex sofp-back-cover-page.tex sofp-back-cover-no-bg.tex cover-background.jpg cover-background-2.jpg monads_evil_face.jpg; do cp book_cover/"$f" .; done

# Prepare "$name-src.tar.bz2" with all sources.
assemble_sources &

(
  (
    cd tex/

    bash ../scripts/spelling_check.sh
    bash ../scripts/check-consistent-labels.sh
    bash ../scripts/check-lines_with_displaymath_in_new_paragraph.sh
    bash ../scripts/check-punctuation-before-code-blocks.sh
  ) | tee build/checks.log
) &

create_main_pdf_file 12pt &

create_main_pdf_file 10pt &

# Wait until PDF builds, source tar, and checks are finished.
wait


main_pdf=pdf-12pt/$name.pdf

attach_sources_to_pdf $main_pdf $name.pdf &

attach_sources_to_pdf pdf-10pt/$name.pdf $name-10pt.pdf &

function archive_build_logs {
  tar jcf "$name-logs.tar.bz2" pdf-*pt/$name*.{log,ilg,idx,toc} build/*.log
  echo "Log files are prepared in $name-logs.tar.bz2"
}

archive_build_logs &

total_pages=`pdfPages $main_pdf`
size=`kbSize $main_pdf`

echo Result is $main_pdf, size $size bytes, with $total_pages pages.

bash scripts/prepare_volume.sh 1 "$pdftk" &
bash scripts/prepare_volume.sh 2 "$pdftk" &
bash scripts/prepare_volume.sh 3 "$pdftk" &


# Wait for background jobs.
wait
