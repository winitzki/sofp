latex chapter3-picture.tex
dvips chapter3-picture.dvi
ps2pdf -dPDFSETTINGS=/prepress -dEmbedAllFonts=true chapter3-picture.ps
rm -f chapter3-picture.{aux,dvi,log,ps}

