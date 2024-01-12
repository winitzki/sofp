# Prepare the printable PDF file of volume v of the book. v = 1, 2, 3.

v=$1
dir=vol$v
name=sofp-$dir

export LC_ALL=C

rm -rf $dir
mkdir $dir
cp sofp*.tex sofp.* *.aux $dir/
cp book_cover/* $dir/
cd $dir

# Remove all content except for this volume.

case $v in
1)
  cat sofp.tex | \
    grep -v '\part{\([^A]\|A[^p]\|Ap[^p]\)' | \
    fgrep -v '\include{sofp-free-type}' | \
    fgrep -v '\include{sofp-functors}' |  \
    fgrep -v '\include{sofp-summary}' |  \
    fgrep -v '\include{sofp-appendices}' \
     > $name.tex

  sed -i .bak -e 's|\(of Functional Programming\)|\1, Part I|' $name.tex
  sed -i .bak -e 's|% End of title.|\\vspace{0.2in}\\centerline{\\fontsize{20pt}{20pt}\\selectfont{Part I. Introductory level}}|' sofp-cover-page-no-bg.tex

       ;;

2)
  cat sofp.tex | \
    grep -v '\part{\([^A]\|A[^p]\|Ap[^p]\)' | \
    fgrep -v '\include{sofp-nameless-functions}' | \
    fgrep -v '\include{sofp-summary}' | \
    fgrep -v '\include{sofp-appendices}' \
     > $name.tex

  sed -i .bak -e 's|with examples in Scala|with examples in Scala. Part II|' $name.tex
sed -i .bak -e 's|% End of title.|\\vspace{0.2in}\\centerline{\\fontsize{20pt}{20pt}\\selectfont{Part II. Intermediate level}}|' sofp-cover-page-no-bg.tex

       ;;

3)
  cat sofp.tex | \
    grep -v '\part{\([^A]\|A[^p]\|Ap[^p]\)' | \
    fgrep -v '\include{sofp-nameless-functions}' | \
    fgrep -v '\include{sofp-functors}' |  \
    fgrep -v '\include{sofp-summary}' |  \
     > $name.tex

  sed -i .bak -e 's|with examples in Scala|with examples in Scala. Part III|' $name.tex
sed -i .bak -e 's|% End of title.|\\vspace{0.2in}\\centerline{\\fontsize{20pt}{20pt}\\selectfont{Part III. Advanced level}}|' sofp-cover-page-no-bg.tex

       ;;

esac

mv $name.tex sofp.tex
pdflatex --interaction=batchmode sofp
makeindex sofp.idx
pdflatex --interaction=batchmode sofp

mv sofp.pdf ../$name.pdf
