# Prepare the printable PDF file of volume v of the book. v = 1, 2, 3.
# The files are designed for printing and will have no PDF hyperlinks.

function pdfPages {
 local file="$1"
 "$pdftk" "$file" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'
}


v=$1
pdftk=$2

dir=vol$v
name=sofp-$dir

export LC_ALL=C

rm -rf $dir
mkdir -p $dir/book_cover
cd $dir

tar jxf ../sofp-src.tar.bz2
mv sofp-src/* .

cp ../sofp*.tex ../sofp.* .
cp ../book_cover/* ./book_cover/

cp book_cover/sofp-cover-parameters.tex.src book_cover/sofp-cover-parameters.tex

function remove_part1 {
    fgrep -v '\part{Introductory level}' | \
    fgrep -v '\include{sofp-nameless-functions}'
}

function remove_part2 {
    fgrep -v '\part{Intermediate level}' | \
    fgrep -v '\include{sofp-functors}'
}

function remove_part3 {
    fgrep -v '\part{Advanced level}' | \
    fgrep -v 'part{Discussions}' | \
    fgrep -v 'part{Appendixes}' | \
    fgrep -v '\appendix' | \
    fgrep -v '\include{sofp-summary}' |  \
    fgrep -v '\include{sofp-appendices}' | \
    fgrep -v '\include{sofp-free-type}'
}

# Set part, section, page counters. \setcounter{page}{1} and so on.
firstpart1=$(fgrep '\contentsline {part}' ../sofp.aux | tail -n +$v | head -1 | sed -e 's|.*{part.\([0-9]\)}.*|\1|')
firstpage1=$(fgrep '\contentsline {part}' ../sofp.aux | tail -n +$v | head -1 | sed -e 's|.*{\([0-9]*\)}{part.[0-9]}.*|\1|')
# Latex will increment those counters immediately. So, we decrement them here before setting.
firstpart=$((firstpart1-1))
firstpage=$((firstpage1-1))

function get_chapter {
  local c=$(fgrep '\contentsline {chapter}' "$1" | head -1 | sed -e 's|.*{chapter.\([0-9]*\)}.*|\1|')
  echo $((c-1))
}

# Remove all content except for this volume.
case $v in
1)
  firstchapter=$(get_chapter ../sofp-nameless-functions.aux)
  cat sofp.tex | remove_part2 | remove_part3  > $name.tex
  sed -i.bak -e 's|\(of Functional Programming\)|\1, Part I|; s|\(\\part{.*}\)|\\setcounter{page}{'$firstpage'}\\setcounter{part}{'$firstpart'}\\setcounter{chapter}{'$firstchapter'}\1|;' $name.tex
  sed -i.bak -e 's|% End of title.|\\vspace{0.2in}\\centerline{\\fontsize{20pt}{20pt}\\selectfont{Part I. Introductory level}}|' book_cover/sofp-cover-page-no-bg.tex

       ;;

2)
  firstchapter=$(get_chapter ../sofp-functors.aux)
  echo "Detected first chapter $firstchapter, first page $firstpage, part number $firstpart"
  cat sofp.tex | remove_part1 | remove_part3  > $name.tex

  sed -i.bak -e 's|\(of Functional Programming\)|\1, Part II|; s|\(\\part{.*}\)|\\setcounter{page}{'$firstpage'}\\setcounter{part}{'$firstpart'}\\setcounter{chapter}{'$firstchapter'}\1|;' $name.tex
  sed -i.bak -e 's|% End of title.|\\vspace{0.2in}\\centerline{\\fontsize{20pt}{20pt}\\selectfont{Part II. Intermediate level}}|' book_cover/sofp-cover-page-no-bg.tex

       ;;

3)
  firstchapter=$(get_chapter ../sofp-free-type.aux)
  cat sofp.tex | remove_part1 | remove_part2  > $name.tex

  sed -i.bak -e 's|\(of Functional Programming\)|\1, Part III|; s|\(\\part{.*}\)|\\setcounter{page}{'$firstpage'}\\setcounter{part}{'$firstpart'}\\setcounter{chapter}{'$firstchapter'}\1|;' $name.tex
  sed -i.bak -e 's|% End of title.|\\vspace{0.2in}\\centerline{\\fontsize{20pt}{20pt}\\selectfont{Part III. Advanced level}}|' book_cover/sofp-cover-page-no-bg.tex

       ;;

esac

cp book_cover/* .

mv $name.tex sofp.tex

# Disable PDF hyperlinks and remove covers.
LC_ALL=C sed -i.bak -e 's|colorlinks=true|colorlinks=false|; s|\\input{sofp-cover-page}||; s|\\input{sofp-back-cover-page}||; ' sofp.tex

pdflatex --interaction=batchmode sofp
makeindex sofp.idx
cp ../*.aux . # Enable references to other chapters.
pdflatex --interaction=batchmode sofp

mv sofp.pdf ../$name.pdf

bash ../prepare_cover.sh ../$name.pdf "$pdftk"
mv book_cover/sofp-3page-cover.pdf ../$name-3page-cover.pdf
