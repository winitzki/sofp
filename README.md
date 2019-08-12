# The Science of Functional Programming

This is the official source repository for the book _The Science of Functional Programming: A tutorial, with examples in Scala_.

The book is a tutorial exposition of the theoretical knowledge that functional programmers need. The material is developed from first principles and shows complete derivations and proofs of substantially all results.

The book is published under the GNU Free Documentation License. Permission is granted to copy, distribute and/or modify this book under the terms of that license.

This repository contains the full source code for the book (LyX and LaTeX / jpg / eps) and shell scripts for building a PDF version of the book. (So this is a "transparent" copy in the sense of the GNU license.)

This repository also contains talk slides for presentations that initiated the work on this book. The talk slides are not part of the book and may be partially obsolete.

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

# Printed version of the draft

A printed version of the draft can be purchased at lulu.com: [http://www.lulu.com/content/paperback-book/the-science-of-functional-programming/24915714](http://www.lulu.com/content/paperback-book/the-science-of-functional-programming/24915714).

This printed version contains only the chapters whose text has been edited and proofread, and corresponds to the PDF file [sofp-src/sofp-draft.pdf](sofp-src/sofp-draft.pdf). 

Readers are invited to create github issues in this repository if they wish to make comments or suggestions regarding the contents of the book.

# Current status of the draft

Chapters 1-6 as well as some appendices and discussion chapters are ready after a second proofreading of the draft. Chapter 13 is in preparation.
