# Prepare the printable PDF file of volume v of the book. v = 1, 2, 3.

pdffile="$1"
pdftk="$2"

function pdfPages {
 local file="$1"
 "$pdftk" "$file" dump_data | fgrep NumberOfPages | sed -e 's,^.* ,,'
}

export LC_ALL=C

total_pages=`pdfPages "$pdffile"`

cd book_cover

sed -i.bak -e "s|TOTALPAGES|$total_pages|" sofp-cover-parameters.tex

bash sofp-make-cover.sh
