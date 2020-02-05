#!/bin/bash

cat sofp*.tex | \
  LC_ALL=C sed -e "s|''| |g; s|\.| |g; s|-| |g; s|lstinline![^!]*!| |g; s|\([A-Za-z]\)'s |\1 |; s|\([A-Za-z]\)'s$|\1|; s|\\[vh]space{[^}]*}||g; s|{https*://[^}]*}||g; " | \
  LC_ALL=C egrep -v '(Source hash|Git commit): [0-9a-f]+' | \
   perl -e '$done=1; while($done) { while(<>){ if(m/\\begin\{comment\}/) { $done=1; last;}; $done=0; print;} while(<>){last if (m/\\end\{comment\}/)}; }; ' | \
   perl -e 'while(<>) { last if (/The following text is quoted in part/i); print; }; while (<>) { last if (/et potat optia alia legali/);}; while(<>) { print;};' | \
   perl -e 'while(<>) { last if (/The purpose of this license/i); print; }; while (<>) { last if (/but changing it is not allowed/);}; while(<>) { print;};' | \
   hunspell -t -l -d en_US | \
   sort | uniq | egrep -iv -f excluded_words > misspelled_words

echo Found `wc -l misspelled_words`.


