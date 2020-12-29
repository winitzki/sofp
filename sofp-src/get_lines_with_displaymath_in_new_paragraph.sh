egrep -n  -B1 '^\\(\[|begin{align)' "$1"|egrep  '^[0-9]+-$' | sed -e 's/-$//'
# Output consists of several line numbers.
