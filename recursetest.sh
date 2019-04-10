#!/bin/bash

shopt -s globstar
for dir in ./**;do
    [[ ! -d $dir ]] && continue # if not directory then skip
    echo "$dir"
done