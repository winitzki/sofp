for a in sofp*tex; do 
  echo "$a"
  LC_ALL=C egrep -n  -B1 '^\\(\[|begin{align)' "$a" | LC_ALL=C egrep  '^[0-9]+-$' | sed -e 's/-$//'
# Output consists of several line numbers.
done
