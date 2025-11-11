#!/bin/bash

# Checks who's been tampering in Git with the files given.

FILES="$@"
LINES=
while [ -n "$1" ]
do
  LINES="$LINES $(git blame --line-porcelain $1 | sed -n 's/^author //p')"
  shift
done
echo "Changed lines:"
echo "$LINES" | sort | uniq -c | sort -rn | head -n 10
echo "Last tamperers:"
git log -20 --date-order --pretty="format:%ai %an" -- $FILES | \
  sort -suk 4 | sort -nrk 1,2 | head -n 10 | \
  sed -e 's/^/    /;s/ [+-][0-9]\{4\}//'
