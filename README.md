# The Science of Functional Programming

This is the official source repository for the new book _The Science of Functional Programming: A tutorial, with examples in Scala_.

The book is a tutorial exposition of the theoretical knowledge that functional programmers need. The material is developed from first principles and contains complete explanations, derivations, and proofs of almost all required results.

A recorded slide presentation, ["Reasoning about types and code"](https://www.youtube.com/watch?v=tgr_dV7_53s), illustrates some of the topics and methods of this book.

# Source code

The book is published under the [GNU Free Documentation License](https://www.gnu.org/licenses/old-licenses/fdl-1.2.en.html). Permission is granted to _copy, distribute and/or modify_ this book under the terms of that license.

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

# Roadmap

- Milestone 1 (achieved as of August 2019): chapters 1-6 are completed and available for purchase at lulu.com as a cheap (black/white) paperback.
- Milestone 2 (ETA: November 2019): chapters 7, 8, 9, 13 are completed. The draft is available for purchase at lulu.com (black/white, cheaper) and at blurb.com (color, more expensive) in paperback.
- Milestone 3 (ETA: end of 2019): chapters 1-13 are completed and available for purchase at lulu.com (black/white, cheaper) and blurb.com (color, more expensive) as both paperback and hardcover versions.
- Milestone 4 (ETA: mid-2020): possibly adding chapters 14-16, the entire book is completed after possible revisions and input from readers.
