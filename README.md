# The Science of Functional Programming

This is the official source repository for the new book _The Science of Functional Programming: A tutorial, with examples in Scala_.

The book is a tutorial exposition of the theoretical knowledge that functional programmers need. The material is developed from first principles and contains complete explanations, derivations, and proofs of almost all required results.

## Related video presentations

["Reasoning about types and code"](https://www.youtube.com/watch?v=tgr_dV7_53s) illustrates some of the topics and methods of this book.

["What did category theory ever did for us (functional programmers)](https://www.youtube.com/watch?v=Zau8CxsfxOo).

["Parametricity properties of purely functional code"](https://youtu.be/vTWLtBTEmAY)

[Functional programming tutorials playlist](https://www.youtube.com/playlist?list=PLcoadSpY7rHXJWbUkjQ3P9MXBbXxLP8kV)
Audio recordings with slides, showing an earlier version of the material in this book.
Many notations and explanations have been revised and improved when writing up the book.

# Source code

The book is published under the [GNU Free Documentation License](https://www.gnu.org/licenses/old-licenses/fdl-1.2.en.html).
Permission is granted to _copy, distribute and/or modify_ this book under the terms of that license.
This means the book is free (as in "freedom") and will stay free forever.

This repository contains the current PDF version (both the [full uncorrected draft](sofp-src/sofp.pdf) and the [finished part of the draft](sofp-src/sofp-draft.pdf))
and also the full source code for the book (LyX and LaTeX / jpg / eps) and shell scripts for building a PDF version of the book.
So, this is a "transparent" copy in the sense of the GNU license.

This repository also contains the slides for YouTube presentations that initiated the work on this book. The talk slides are not part of the book and may be partially obsolete both in content and in the notation used.

# Current status of the book

Chapters 1-10 as well as some appendices and discussion chapters are ready after a second proofreading of the draft. Chapter 14 is in preparation.

# Leanpub version of the draft

The draft version is [available for purchase on leanpub](https://leanpub.com/sofp) for people who want to be notified about updates.

# Printed version of the draft

A printed version of the current draft [can be purchased at lulu.com](https://www.lulu.com/en/us/shop/sergei-winitzki/the-science-of-functional-programming-draft-version/paperback/product-1y5zzgje.html).

This printed version contains only the chapters whose text has been edited and proofread. It corresponds to the PDF file
[sofp-src/sofp-draft.pdf](sofp-src/sofp-draft.pdf).

Readers are invited to create github issues in this repository and comment if they find something not clearly explained or wrong in the book,
or if they wish to make comments or suggestions regarding the contents of the book.


# Roadmap

- Milestone 1 (achieved as of August 2019): chapters 1-6 are completed and available for purchase at lulu.com as a cheap (black/white) paperback.
- Milestone 2 (achieved as of December 2019): chapters 1-9 are completed.
- Milestone 3 (ETA: March 2020): chapters 10 and 14 are completed. The draft is available for purchase at lulu.com (black/white, cheaper) and at blurb.com (color, more expensive) in paperback.
- Milestone 4 (ETA: May 2020): chapters 1-14 are completed and available for purchase at lulu.com (black/white, cheaper) and blurb.com (color, more expensive) as both paperback and hardcover versions.
- Milestone 5 (ETA: June 2020): possibly adding chapters 15-16 (not yet decided, may need to cut scope), the entire book is completed after possible revisions and input from readers.

# Building a PDF version of the book from LyX sources

The current build of the full PDF file is available as [sofp-src/sofp.pdf](sofp-src/sofp.pdf).
It contains the proofread chapters as well as some chapters that are not ready and may contain some partial text and some older slides.

If you want to build from source, currently you need `LyX` 2.3.x and `pdftk` installed. 

`bash make_sofp_pdf.sh` builds the PDF file `sofp.pdf`.

If you do not have `LyX`, you can simply build from the provided LaTeX sources using commands such as

```bash
pdflatex sofp.tex
```
