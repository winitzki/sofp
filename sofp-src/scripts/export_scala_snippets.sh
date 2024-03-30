# This script needs to run in the directory sofp-src/ .
# Export Scala code snippets.
name=sofp
rm -rf mdoc; mkdir mdoc
test -d mdoc_src || mkdir mdoc_src
for f in tex/$name-*.tex; do
  g=`basename "$f" .tex`
  touch mdoc_src/$g.pre.md
  # Remove control annotations for Scala code snippets.
  cat mdoc_src/$g.pre.md <(cat $f | LC_ALL=C sed -e 's|  *// *IGNORETHIS.*||;' | perl scripts/extract_scala_snippets.pl) > mdoc/$g.md
done
