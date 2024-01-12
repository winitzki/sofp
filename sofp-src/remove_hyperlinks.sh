name="$1"
	# Create a full pdf without hyperlinks, for printing on paper. Remove the cover image from first page and the back cover image.
	# Assume that all files have been processed, use fast processing.
	mv "$name.pdf" "$name-hyperlinks.pdf"
	LC_ALL=C sed -i.bak -e 's|colorlinks=true|colorlinks=false|; s|\\input{sofp-cover-page}||; s|\\input{sofp-back-cover-page}||; ' $name.tex 
	#make_pdf_with_index $name fast
	pdflatex --interaction=batchmode "$name"
	mv "$name.pdf" "$name-nohyperlinks.pdf"
	mv "$name-hyperlinks.pdf" "$name.pdf"
