# Input: chapter3-picture.tex
# Output: chapter3-picture.pdf
logfile="../chapter3-figure-build.log"
latex chapter3-picture.tex >& "$logfile"
dvips chapter3-picture.dvi >& "$logfile"
ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true chapter3-picture.ps >& "$logfile"
rm -f chapter3-picture.dvi chapter3-picture.ps
