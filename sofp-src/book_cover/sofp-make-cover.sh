#!/bin/bash

for f in sofp-spine sofp-back-cover sofp-front-cover; do
pdflatex --interaction=batchmode "$f"
done
pdflatex --interaction=batchmode sofp-3page-cover


