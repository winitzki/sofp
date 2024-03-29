#!/bin/bash
for a in sofp*tex; do 
  b=linenumbers-p-$a
  LC_ALL=C egrep -n  -B1 '^(\\begin{lstlisting}|\\\[$)' "$a" \
   | LC_ALL=C egrep -v '^[0-9]+-.*[]):%},.~] *$' \
   | LC_ALL=C egrep '^[0-9]+-[^ ]' \
   | LC_ALL=C sed -e 's/^x\([0-9][0-9]*\)-.*$/\1/' \
   | LC_ALL=C sed -e 's/^\(.*\)$/"\1"/' > $b
  test -s $b && {
    echo "Warning: file $a has no punctuation before code blocks or display math at lines:"
    cat $b
 }
 rm -f $b
# Output may contain several line numbers.
done
