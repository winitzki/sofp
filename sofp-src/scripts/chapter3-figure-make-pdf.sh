# This script runs in a tex/ source directory.

# Input: chapter3-picture.tex
# Output: chapter3-picture.pdf
logfile="../build/chapter3-picture-build.log"
latex chapter3-picture.tex >& "$logfile"
dvips chapter3-picture.dvi >& "$logfile"
ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true chapter3-picture.ps >& "$logfile"
mv chapter3-picture.log ../build/
rm -f chapter3-picture.{tex,aux,dvi,ps}
