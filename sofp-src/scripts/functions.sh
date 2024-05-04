name="sofp"

function git_commit_hash {
	git rev-parse HEAD # Do not use --short here.
}

function source_hash {
	cat $name*.lyx | shasum -a 256 | cut -c 1-64
}

# Make a PDF package with embedded source archive.

# This function is not used now.
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

function add_source_hashes {
	gitcommit=`git_commit_hash`
	sourcehash=`source_hash`
	echo $sourcehash > $name.source_hash1
	LC_ALL=C sed -i.bak -E -e "s/INSERTSOURCEHASH/$sourcehash/; s/INSERTGITCOMMIT/$gitcommit/" $name.tex
	mv $name.source_hash1 $name.source_hash
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
  rm -f tex/*.lyx tex/*.bak tex/sofp.source_hash lyx/*~ lyx/\#* # Copies of LyX files and other temporary files from tex/ should not be in sources.
  test -d build || mkdir build
	tar jcvf build/"$name-src.tar.bz2" \
	 README*.md LICENSE *.sh scripts tex/chapter3-picture.pdf cover tex/*.tex lyx/*.lyx \
	  >& /dev/null
	size=$(kbSize build/"$name-src.tar.bz2")
	echo "File build/$name-src.tar.bz2 created, size $size bytes."
}

function kbSize {
 local file="$1"
 ls -l -n "$file"|sed -e 's/  */ /g'|cut -f5 -d ' '
}

function pdfPages {
 local file="$1"
 "$pdftk" "$file" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'
}

function insert_examples_exercises_count {
	local target="$1"
	local exercises=`cat $name-*.tex | LC_ALL=C fgrep -c '\subsubsection{Exercise '`
	local examples=`cat $name-*.tex | LC_ALL=C fgrep -c '\subsubsection{Example '`
	local codesnippets=`cat $name-*.tex | LC_ALL=C fgrep -c '\begin{lstlisting}'`
	local stmts=`cat $name-*.tex | LC_ALL=C fgrep -c '\subsubsection{Statement '`
	local diagrams=`cat $name-*.tex | LC_ALL=C fgrep -c '\xymatrix{'`
	local bdate=`date -R`
	local osinfo=`uname -s`
	local pdftex=`pdflatex --version | fgrep pdfTeX\ 3.14`
	LC_ALL=C sed -i.bak -e "s|PDFTEXVERSION|$pdftex|g;  s|BUILDDATE|$bdate|g; s|BUILDOPERATINGSYSTEM|$osinfo|g; s,NUMBEROFEXAMPLES,$examples,g; s,NUMBEROFEXERCISES,$exercises,g; s,NUMBEROFDIAGRAMS,$diagrams,g; s,NUMBEROFSTATEMENTS,$stmts,g; s,NUMBEROFCODESNIPPETS,$codesnippets,g;" "$target"
}

function attach_sources_to_pdf {
  local src=$1 target=$2
  "$pdftk" "$src" attach_files build/"$name-src.tar.bz2" output "$target"
}

function create_main_pdf_file {
  local pt=$1 # Font size in points. Must be one of 10pt, 11pt, 12pt.
  local targetdir=pdf-$pt
  echo "Creating the full PDF file in $targetdir..."
  rm -rf $targetdir; mkdir $targetdir
  cp -r tex/* $targetdir/
  (
    cd $targetdir
    # Set font size.
    LC_ALL=C sed -i.bak -e "s|fontsize=[0-9]*pt|fontsize=$pt|" $name.tex

    # Output is $name.pdf, main file is $name.tex, and other .tex files are \include'd.
    bash ../scripts/run_pdflatex_with_index.sh "$name" >& ../build/build_main_pdf.log
  )
}

function archive_build_logs {
  tar jcf build/"$name-logs.tar.bz2" pdf-*pt/$name*.{log,ilg,idx,toc} build/*.log
  echo "Log files are prepared in build/$name-logs.tar.bz2"
}
