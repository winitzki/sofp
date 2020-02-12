cat misspelled_words|while read word; do echo "^$word\$" >> excluded_words; done
