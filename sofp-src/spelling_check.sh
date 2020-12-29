#!/bin/bash

echo "Checking spelling with hunspell..."

cat sofp*.tex | \
  LC_ALL=C sed -e "s|\\[vh]space{[^}]*}||g; s|\$iw||; s|{https*://[^}]*}||g; s|G\\\\\"odel||g; s|Theor\.~||; s|''| |g; s|\.| |g; s|-| |g; s|lstinline![^!]*!| |g; s|\([A-Za-z]\)'s |\1 |; s|\([A-Za-z]\)'s$|\1|; " | \
  LC_ALL=C egrep -v '(Source hash|Git commit): [0-9a-f]+' | \
   perl -e '$done=1; while($done) { while(<>){ if(m/\\begin\{comment\}/) { $done=1; last;}; $done=0; print;} while(<>){last if (m/\\end\{comment\}/)}; }; ' | \
   perl -e 'while(<>) { last if (/The following text is quoted in part/i); print; }; while (<>) { last if (/et potat optia alia legali/);}; while(<>) { print;};' | \
   perl -e 'while(<>) { last if (/The purpose of this license/i); print; }; while (<>) { last if (/but changing it is not allowed/);}; while(<>) { print;};' | \
   tee tempfile | \
   hunspell -t -l -d en_US | \
   sort | uniq | egrep -iv -f excluded_words > misspelled_words

echo Found `wc -l misspelled_words`.
rm -rf tempfile

