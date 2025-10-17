ex=scripts/excluded_words
sed -e 's|^\(.*\)$|^\1$|' < tex/misspelled_words >> $ex
sort $ex | uniq > $ex.1
mv $ex.1 $ex
