base="$1"
echo "Running pdfltex for $base"
pdflatex --interaction=batchmode "$base"
makeindex "$base.idx"
pdflatex --interaction=batchmode "$base"

if ! test -s "$base".pdf; then
		echo Output file "$base".pdf not found, exiting.
		exit 1
else
	  echo "File $base.pdf is ready."
fi
