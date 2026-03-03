#!/bin/bash
 
# Checks who's been tampering in git with the files given.
 
declare -a files
files=("$@")

echo 'Changed lines:'
for file in "${files[@]}"
do
  git blame --line-porcelain "$file" | sed --quiet --expression 's/^author //p'
done \
  | sort \
  | uniq --count \
  | sort --numeric-sort --reverse \
  | head --lines 10

echo 'Last tamperers:'
git log -20 --date-order --pretty='format:%ai %an' -- "${files[@]}" \
  | sort --key 4 --stable --unique \
  | sort --key 1,2 --numeric-sort --reverse \
  | head --lines 10 \
  | sed --expression 's/^/  /;s/ [+-][0-9]\{4\}//'
