#!/bin/bash

# Inputs:
# sofp-spine.tex
#   sofp-cover-parameters.tex
#
# sofp-back-cover.tex
#   sofp-cover-parameters.tex sofp-back-cover-no-bg.tex
#
# sofp-back-cover-no-bg.tex (generated from sofp-back-cover-no-bg.tex.src)
#   monads_evil_face.jpg <barcode>.pdf
#
# sofp-front-cover.tex
#   sofp-cover-parameters.tex sofp-cover-page-no-bg.tex
#
# sofp-cover-for-main-pdf.tex
#   cover-background.jpg sofp-cover-page-no-bg.tex
# sofp-back-cover-for-main-pdf.tex
#   cover-background.jpg sofp-back-cover-no-bg.tex


# Prepare the three cover pages in parallel.

for f in sofp-spine sofp-back-cover sofp-front-cover; do
  pdflatex --interaction=batchmode "$f" &
done
wait # Wait until all 3 cover pages are done.

# Inputs:
# sofp-3page-cover.tex
#   sofp-spine.pdf sofp-back-cover.pdf sofp-front-cover.pdf cover-background-2.jpg
pdflatex --interaction=batchmode sofp-3page-cover
pdflatex --interaction=batchmode sofp-3page-cover
