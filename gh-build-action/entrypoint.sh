#!/usr/bin/env bash

cd $GITHUB_WORKSPACE
cd sofp-src
echo "Running in $(pwd)"

rm  *.tex
lyx --export pdflatex sofp.lyx
pdflatex sofp.tex
makeindex sofp.idx
pdflatex sofp.tex
