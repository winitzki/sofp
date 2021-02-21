#!/bin/bash

for f in sofp-spine sofp-back-cover sofp-front-cover; do
pdflatex --interaction=batchmode "$f"
done
pdflatex sofp-3page-cover


