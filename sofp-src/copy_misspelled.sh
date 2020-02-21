ex=excluded_words
sed -e 's|^\(.*\)$|^\1$|' < misspelled_words >> $ex
sort $ex > $ex.1
mv $ex.1 $ex
