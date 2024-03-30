#!/bin/bash
for a in sofp*tex; do 
  b=linenumbers-$a
  LC_ALL=C egrep -n  -B1 '^\\(\[|begin{align)' "$a" | LC_ALL=C egrep  '^[0-9]+-$' | sed -e 's/-$//' > $b
  test -s $b && {
    echo "Warning: file $a has display math in new paragraphs at lines:"
    cat $b
 }
 rm -f $b
# Output may contain several line numbers.
done
