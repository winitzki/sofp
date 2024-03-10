#!/bin/bash
# Prepare the three cover pages in parallel.
(
for f in sofp-spine sofp-back-cover sofp-front-cover; do
pdflatex --interaction=batchmode "$f" &
done
wait # Wait until all 3 cover pages are done.
pdflatex --interaction=batchmode sofp-3page-cover
) >& /dev/null
