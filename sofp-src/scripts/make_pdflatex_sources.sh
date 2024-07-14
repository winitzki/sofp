# This script needs to run in the directory sofp-src/ .

# Inputs: lyx/ directory with all sources.
# Outputs: tex/ directory with preprocessed pdflatex files, and mdoc/ directory with exported code snippets.

source scripts/functions.sh

if [ x"$lyx" == x ]; then lyx=`which lyx`; else echo "Using $lyx"; fi

function add_color {
	local texsrc="$1"
	# Insert color comments into displayed equation arrays. Also, in some places the green color was inserted; replace by `greenunder`.
	# Example of inserted color: {\color{greenunder}\text{outer-interchange law for }M:}\quad &
	LC_ALL=C sed -i.bak -e 's|\\color{green}|\\color{greenunder}|; s|^\(.*\\text{[^}]*}.*:\)\( *\\quad \& \)|{\\color{greenunder}\1}\2|; s|\(\& *\\quad\)\(.*\\text{[^}]*}.*: *\)\(\\quad\(\\nonumber \)*\\\\\)$|\1{\\color{greenunder}\2}\3|' "$texsrc"
	# Insert color background into all displayed equations. This is disabled because it does not always produce visually good results.
	if false; then
	LC_ALL=C sed -i.bak -E -e ' s!\\begin\{(align.?|equation)\}!\\begin{empheq}[box=\\mymathbgbox]{\1}!; s!\\end\{(align.?|equation)\}!\\end{empheq}!; ' "$texsrc"
	LC_ALL=C sed -i.bak -E -e ' s!^\\\[$!\\begin{empheq}[box=\\mymathbgbox]{equation*}!; s!^\\\]$!\\end{empheq}!; ' "$texsrc"
	fi
}

function add_color_to_equation_displays {
  for f in $name-*.tex; do
    add_color "$f" &
  done
}

echo "Copying LyX files to TeX source directory..."

rm -rf tex

cp -r lyx tex

# Source file for the back cover blurb. This file will be modified.
cp cover/sofp-back-cover-no-bg.tex.src tex/sofp-back-cover-no-bg.tex

# Source files used by the main pdf.
cp cover/cover-background.jpg cover/sofp-cover-for-main-pdf.tex cover/sofp-cover-page-no-bg.tex cover/sofp-back-cover-for-main-pdf.tex tex/

cd tex/

bash ../scripts/chapter3-figure-make-pdf.sh &

echo "Exporting LyX files $name.lyx and its child documents into LaTeX..."
"$lyx" $lyxdir -f all --export pdflatex $name.lyx # Exports LaTeX for all child documents as well.

(
  cd ..
  bash scripts/export_scala_snippets.sh
) &

#### The LaTeX files are heavily post-processed after exporting from LyX.

echo "Post-processing LaTeX files..."

add_source_hashes $name.tex & # Compute source hash from LyX files only. Add it to the root tex file.

# Insert the number of examples and exercises.
# This replacement is needed for the root file and for the back cover.
insert_examples_exercises_count $name.tex
insert_examples_exercises_count sofp-back-cover-no-bg.tex

## Remove mathpazo? This was a mistake: should not remove it.
#LC_ALL=C sed -i.bak -e 's/^.*usepackage.*mathpazo.*$//' $name.tex

# Replace ugly Palatino quote marks and apostrophes by sans-serif marks.
LC_ALL=C sed -i.bak -e " s|'s|\\\\textsf{'}s|g; s|O'|O\\\\textsf{'}|g; s|s'|s\\\\textsf{'}|g; "' s|``|\\textsf{``}|g; s|“|\\textsf{``}|g; '" s|''|\\\\textsf{''}|g; s|”|\\\\textsf{''}|g;  s|\\\\textsf{'}'|\\\\textsf{''}|g; " $name-*.tex

rm -rf *.bak &

add_color_to_equation_displays

wait
