# Prepare the printable PDF file of volume v of the book. v = 1, 2, 3.
# The files are designed for printing and will have no color in the PDF hyperlinks.

function pdfPages {
 local file="$1"
 "$pdftk" "$file" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'
}

vol1_ISBN="ISBN (vol.~1): 978-1-4710-4004-7"
vol1_ISBN_barcode="vol1_isbn_barcode.pdf"
vol1_url="https://www.lulu.com/shop/sergei-winitzki/the-science-of-functional-programming-part-i/paperback/product-dyyq2zm.html"

vol2_ISBN="ISBN (vol.~2): 978-1-4461-9146-0"
vol2_ISBN_barcode="vol2_isbn_barcode.pdf"
vol2_url="https://www.lulu.com/shop/sergei-winitzki/the-science-of-functional-programming-part-ii/paperback/product-655e7wm.html"

vol3_ISBN="ISBN (vol.~3): 978-1-4461-9136-1"
vol3_ISBN_barcode="vol3_isbn_barcode.pdf"
vol3_url="https://www.lulu.com/shop/sergei-winitzki/the-science-of-functional-programming-part-ii/paperback/product-p668z4q.html"

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
firstpage=$((firstpage1-0))

function get_chapter {
  local c=$(fgrep '\contentsline {chapter}' "$1" | head -1 | sed -e 's|.*{chapter.\([0-9]*\)}.*|\1|')
  echo $((c-1))
}

# Remove all content except for this volume.
case $v in
1)
  firstchapter=$(get_chapter ../sofp-nameless-functions.aux)
  cat sofp.tex | remove_part2 | remove_part3  > $name.tex
  title1="Part I"
  title2="Part I: Introductory level"
  url="$vol1_url"
  isbn="$vol1_ISBN"
  barcode="$vol1_ISBN_barcode"
  ;;

2)
  firstchapter=$(get_chapter ../sofp-functors.aux)
  cat sofp.tex | remove_part1 | remove_part3  > $name.tex
  title1="Part II"
  title2="Part II: Intermediate level"
  url="$vol2_url"
  isbn="$vol2_ISBN"
  barcode="$vol2_ISBN_barcode"
  ;;

3)
  firstchapter=$(get_chapter ../sofp-free-type.aux)
  cat sofp.tex | remove_part1 | remove_part2  > $name.tex
  title1="Part III"
  title2="Part III: Advanced level"
  url="$vol3_url"
  isbn="$vol3_ISBN"
  barcode="$vol3_ISBN_barcode"
  ;;

esac

  echo "Detected previous chapter $firstchapter, first page $firstpage, previous part number $firstpart"

  sed -i.bak -e 's|\(of Functional Programming\)|\1, '"$title1"'|; s|\(\\part{.*}\)|\\setcounter{page}{'$firstpage'}\\setcounter{part}{'$firstpart'}\\setcounter{chapter}{'$firstchapter'}\1|;' $name.tex

  # Subtitle on cover page.
  sed -i.bak -e 's|% End of title.|\\vspace{0.2in}\\centerline{\\fontsize{20pt}{20pt}\\selectfont{'"$title2"'}}|' book_cover/sofp-cover-page-no-bg.tex

  # Title on spine.
  sed -i.bak -e 's|\(of Functional Programming\)|\1, '"$title1"'|;' book_cover/sofp-spine.tex

  # Replace lulu.com hyperlink.
  sed -i.bak -e 's|{https://www.lulu.com/[^}]*}{\(Print on demand[^}]*\)}|{'"$url"'}{\1}|;' $name.tex

  # Replace ISBN information.
  echo "Using volume $v ISBN '$isbn'"
  sed -i.bak -e 's|\({\\footnotesize{}\)ISBN: [^}]*\(}\\\\\)|\1'"$isbn"'\2|;' $name.tex
  # Add barcode to back cover.
  sed -i.bak -e 's|%\(.*\){barcode}.*|\1{'"$barcode"'}|' book_cover/sofp-back-cover-no-bg.tex

cp book_cover/* .

mv $name.tex sofp.tex

# Disable PDF hyperlinks and remove covers.
LC_ALL=C sed -i.bak -e 's|colorlinks=true|colorlinks=false|; s|\\input{sofp-cover-page}||; s|\\input{sofp-back-cover-page}||; ' sofp.tex
echo "Starting to prepare volume $v"
(
pdflatex --interaction=batchmode sofp  /dev/null
makeindex sofp.idx 
cp ../*.aux . # Enable references to other chapters.
pdflatex --interaction=batchmode sofp
) >& /dev/null
mv sofp.pdf ../$name.pdf
echo "Volume $v is prepared in $name.pdf"

bash ../prepare_cover.sh ../$name.pdf "$pdftk"
mv book_cover/sofp-3page-cover.pdf ../$name-3page-cover.pdf
echo "Cover for volume $v is prepared in $name-3page-cover.pdf"
