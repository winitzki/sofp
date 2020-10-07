#!/usr/bin/env bash

cd sofp-src

rm  *.tex
lyx --export pdflatex sofp.lyx
pdflatex sofp.tex
makeindex sofp.idx
pdflatex sofp.tex
