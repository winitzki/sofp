#!/bin/bash

# Requires pdftk and shasum.
# For Mac, get pdftk from https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.11-setup.pkg

name="sofp"

# Expected total number of pages in the book draft:
draft_pages=468

# The number of pages in each chapter:
pagecounts=(3 17 42 34 24 49 43 12 63 54 63 11 6 13 100 2 5 6 4 6 3 5 17 1 2 1 1 5)

# To create the draft version that contains only proofread chapters:
# cut out from here,
draft_title_1="Applicative functors,"
# to here:
draft_title_2="Applied functional type theory"
# and then cut out from here:
draft_title_3="Inferring code from types with the LJT algorithm"
# to here:
draft_title_4="D Parametricity theorem"

# Checking the page counts.

# A unique fragment of the title of each chapter:
chapters=("Preface" "Mathematical formulas as code. I." \
 "Mathematical formulas as code. II." "The logic of types. I." "The logic of types. II." \
 "The logic of types. III." "Functors, contrafunctors, and profunctors"  \
 "Reasoning about code." "Typeclasses and functions of types" "Computations in functor blocks. I." \
 "Computations in functor blocks. II." "Applicative functors, contrafunctors, and profunctors" \
 "Traversable functors and profunctors" "\`\`Free'' type constructions" "Computations in functor blocks. III." \
 "Sample problems" \
 "\`\`Applied functional type theory'': A proposal" "Essay: Software engineers and software artisans" \
 "Essay: Towards functional data engineering with Scala" \
 "A Notations" "B Glossary of terms" "C Inferring code from types" \
 "D Parametricity theorem" "E A humorous disclaimer" "F GNU Free Documentation License" \
 "List of Tables" "List of Figures" "Index" "END_OF_BOOK")

function kbSize {
 local file="$1"
 ls -l -n "$file"|sed -e 's/  */ /g'|cut -f5 -d ' '
}

# This requires pdftk to be installed on the path. Edit the next line as needed.
pdftk=`which pdftk`

echo "Info: Using pdftk from '$pdftk'"

draft="$name-draft"

function pdfPages {
 local file="$1"
 "$pdftk" "$file" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'
}

function create_draft {
	echo "Creating draft version with proofread chapters only..."
	local base="$1" output_pdf="$2"
	"$pdftk" $name.pdf dump_data output $name.data
	egrep -v 'Bookmark(Level|Begin)' $name.data|fgrep Bookmark|perl -e 'undef $/; while(<>){ s/\nBookmarkPageNumber/ BookmarkPageNumber/ig; print; }' | tee $name.chapters | \
	egrep "($draft_title_1|$draft_title_2|$draft_title_3|$draft_title_4)" | egrep -o '[0-9]+$' | \
		(read b1; read e1; read b2; read e2; \
                 pdftk sofp.pdf cat 1-$((b1-1)) $e1-$((b2-1)) $e2-end output $output_pdf; \
                 echo Draft page ranges 1-$((b1-1)) $e1-$((b2-1)) $e2-end )

	# Check that the page number did not grow by mistake after wrong formatting.
	local got_draft_pages=`pdfPages $output_pdf`
	if [ $got_draft_pages -eq $draft_pages ]; then
		echo Draft file created as $output_pdf, size `kbSize $output_pdf` bytes, with $draft_pages pages as expected.
	else
		echo Error: Draft file has $got_draft_pages pages instead of expected $draft_pages. Please check.
	fi

	echo "Checking page counts..."
	totalchapters=${#chapters[@]}
	for c in `seq 1 $((totalchapters-1))`; do
		b=$((c-1))
		chapter="${chapters[b]}"
		nextchapter="${chapters[c]}"
		begin_page=`fgrep \ "$chapter"\   $name.chapters  | egrep -o '[0-9]+$'`
		if [ "$nextchapter" == END_OF_BOOK ]; then
			end_page=`pdfPages $name.pdf`
		else
			end_page=`fgrep \ "$nextchapter"\   $name.chapters  | egrep -o '[0-9]+$'`
		fi
		count=$((end_page-begin_page))
		expected=${pagecounts[b]}
#		echo "DEBUG: chapter=$chapter begin_page=$begin_page nextchapter=$nextchapter end_page=$end_page expected=$expected"
		if [ $count -ne $expected ]; then
			echo "Error: Chapter $chapter should have $expected pages but has $count pages instead."
		fi
	done
	echo Done.
}

# Create the lulu.com draft file by selecting the chapters that have been proofread.
create_draft $name $draft.pdf
