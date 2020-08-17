#!/bin/bash

# Print any labels that are inconsistent.

grep ^.subsubsection sofp*tex|LC_ALL=C sed -e 's|.*subsubsection.*label{\(.*\)}.*ref{\([^}]*\)}.*|\1  \2|' |while read a b; do if [ "$a" != "$b" ]; then echo Inconsistent labels: "$a" vs. "$b" ;fi; done
