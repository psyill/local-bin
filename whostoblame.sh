#!/bin/bash

# Checks who's been tampering in git with the files given.

declare -a files
files=("$@")

number_of_cores=$(getconf _NPROCESSORS_ONLN)

function limit_parallel_jobs_to() {
  while (($(jobs -p -r | wc -l) >= "$1"))
  do
    wait -n
  done
}

fifo_name="$(mktemp --dry-run)"
mkfifo "$fifo_name"
trap "rm -f $fifo_name" EXIT

echo 'Changed lines:'
sort < "$fifo_name" \
  | uniq --count \
  | sort --numeric-sort --reverse \
  | head --lines 10 &

(
  for file in "${files[@]}"
  do
    git blame --line-porcelain "$file" | (flock --no-fork "$fifo_name" sed --quiet --expression 's/^author //p' > "$fifo_name") &
    limit_parallel_jobs_to "$number_of_cores"
  done
  wait
)
wait

echo 'Last tamperers:'
git log -20 --date-order --pretty='format:%ai %an' -- "${files[@]}" \
  | sort --key 4 --stable --unique \
  | sort --key 1,2 --numeric-sort --reverse \
  | head --lines 10 \
  | sed --expression 's/^/  /;s/ [+-][0-9]\{4\}//'
