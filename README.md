# The Science of Functional Programming

This is the official source repository for the book _The Science of Functional Programming: A tutorial, with examples in Scala_.

The book is a tutorial exposition of the theoretical knowledge that functional programmers need. The material is developed from first principles and shows complete derivations and proofs of substantially all results.

This repository contains the full source code for the book (LyX and LaTeX / jpg / eps) and shell scripts for building a PDF version of the book.

This repository also contains talk slides for presentations that initiated the work on this book.

# Building a PDF version of the book from LyX sources

The current PDF build is available as [sofp-src/sofp.pdf](sofp-src/sofp.pdf).

If you want to build from source, currently you need `LyX` 2.3.x and `pdftk` installed. 

`bash make_sofp_pdf.sh` builds the PDF file `sofp.pdf`.

If you do not have `LyX`, you can simply build from the provided LaTeX sources using commands such as

```bash
latex sofp.tex
latex sofp.tex
latex sofp.tex
makeindex sofp.idx
latex sofp.tex
latex sofp.tex
dvips sofp.dvi
ps2pdf sofp.ps
```


