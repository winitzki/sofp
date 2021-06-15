![License](https://img.shields.io/github/license/winitzki/sofp.svg)
[![GitHub release](https://img.shields.io/github/release/winitzki/sofp.svg?include_prereleases)](https://github.com/winitzki/sofp/releases)
[![SOFP build status](https://github.com/winitzki/sofp/workflows/Build%20PDF/badge.svg)](https://github.com/winitzki/sofp/actions)

# The Science of Functional Programming

This is the official source repository for the new book _The Science of Functional Programming: A tutorial, with examples in Scala_.

<img src="cover/book-draft-cover.png" width="150px" alt="Book cover"/>

The book is a tutorial exposition of the theoretical knowledge that functional programmers need. The material is developed from first principles and contains complete explanations, derivations, and proofs of almost all required results.

## Discussions about the book

[Discuss the book on github](https://github.com/winitzki/sofp/discussions)

## Related video presentations

[Explaining "theorems for free" and parametricity](https://youtu.be/nSyG5USX3-c)

[Explaining Curry-Howard correspondence](https://youtu.be/XYs1Xg1JbVY)

[What did functional programming ever do for us](https://youtu.be/glDudJ3fqLk)

[Reasoning about types and code](https://www.youtube.com/watch?v=tgr_dV7_53s) illustrates some of the topics and methods of this book.

[What did category theory ever do for us (functional programmers)](https://www.youtube.com/watch?v=Zau8CxsfxOo)

[Parametricity properties of purely functional code](https://youtu.be/vTWLtBTEmAY)

[Playlist: Functional programming tutorials](https://www.youtube.com/playlist?list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)
contains audio recordings with slides. The tutorials show an early version of the material in this book.
Many notations and explanations have been revised and improved when writing up the text of the book.

# Source code

The book is published under the [GNU Free Documentation License](https://www.gnu.org/licenses/old-licenses/fdl-1.2.en.html).
Permission is granted to _copy, distribute and/or modify_ this book under the terms of that license.
For those unfamiliar with the GNU FDL: this means the book is free (as in "freedom")
-- free to use, to copy, to modify, and to distribute -- and will stay free forever, because any modified copy must have full modified sources distributed under the same license.

This `git` repository
contains the full source code for the book (LyX / LaTeX / jpg / pdf) and shell scripts for building a PDF version of the book.
So, this is a "transparent" copy in the sense of the GNU license; the source code of the book is in a format that is convenient to use and to modify.

The ["Releases" section](https://github.com/winitzki/sofp/releases) of this repository contains (under "Assets") the full uncorrected draft (`sofp.pdf`)
and the finished and proof-read part of the draft (`sofp-draft.pdf`).
The latest release is
[![GitHub release](https://img.shields.io/github/release/winitzki/sofp.svg?include_prereleases)](https://github.com/winitzki/sofp/releases)
and represents the most recent, relatively stable version of the text.

This repository also contains the slides for YouTube presentations that initiated the work on this book.
The talk slides are not part of the book and are partially obsolete both in content and in the notation used.

# Current status of the book

Chapters 1-10 and 14, as well as some appendices and discussion chapters are ready after a second proofreading of the draft.

Chapters 11-13 and two more appendices are under construction.

# Leanpub version of the draft

The draft version is [available for purchase on leanpub](https://leanpub.com/sofp) for people who want to be notified about updates.

# Printed version of the draft

A printed version of the current draft [can be purchased at lulu.com](https://www.lulu.com/en/us/shop/sergei-winitzki/the-science-of-functional-programming-draft-version/paperback/product-1y5zzgje.html).

This printed version contains only the chapters whose text has been edited and proofread. It corresponds to the PDF file
`sofp-draft.pdf`  (see the ["Releases / Assets" section of github](https://github.com/winitzki/sofp/releases)).

Readers are invited to create github issues in this repository and comment if they find something not clearly explained or wrong in the book,
or if they wish to make comments or suggestions regarding the contents of the book.


# Roadmap

- Milestone 1 (achieved as of August 2019): chapters 1-6 are completed and available for purchase at lulu.com as a cheap (black/white) paperback.
- Milestone 2 (achieved as of December 2019): chapters 1-9 are completed.
- Milestone 3 (achieved as of November 2020): chapters 10 and 14 are completed.
- Milestone 4 (ETA: January 2021): chapters 1-14 are completed and available for on-demand printing at lulu.com or elsewhere.

# Building a PDF version of the book from LyX sources

If you want to build from source, currently you need `LyX` 2.3.x and `pdftk` installed. 

The command `bash make_sofp_pdf.sh` builds PDF files `sofp.pdf` and `sofp-draft.pdf`.
The first file is a full draft with some unfinished chapters,
the second file contains only finished and proofread chapters.

If this does not work, you can build manually with a simple command such as `lyx --export pdf sofp.lyx`,
but the resulting PDF version will lack certain cosmetic features such as special colors and formatting.

If you do not have `LyX`, you can simply build from the provided LaTeX sources using commands such as

```bash
pdflatex --interaction=batchmode sofp.tex
makeindex sofp.idx
pdflatex --interaction=batchmode sofp.tex
```

# Docker image for PDF builds

A Docker image (containing a compatible version of LyX and LaTeX) is configured by the repository https://github.com/winitzki/sofp-docker-build
and is automatically uploaded to Docker Hub at https://hub.docker.com/repository/docker/winitzki/sofp-docker-build/builds

This Docker image is loaded by the file [build-pdf.yml](.github/workflows/build-pdf.yml#L31) in order to build the PDF version of the book.

The latest build is uploaded to Github when a new git tag is pushed, which 
