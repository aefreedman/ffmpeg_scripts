#!/bin/bash

v=false
DIR=""

usage () { echo $'Aaron\'s convenient file renamer\nArguments:\n-v dry run with file info\n-d parent directory of folders with files\n-D use script\'s root directory as source location\n-h help'; }

fixspaces () { find $1 -name "* *.*" -type f -print0 | \
  while read -d $'\0' f; do mv -v "$f" "${f// /_}"; done }

findspaces () { find $1 -name "* *.*" -type f -print0 | \
  while read -d $'\0' f; do echo $f; done }

while getopts d:Dvh opt; do
[[ ${OPTARG} == -* ]] && { echo "Missing argument for -${opt}" ; exit 1 ; }
case "${opt}"
in
    v) v=true;;
    d) DIR=${OPTARG};;
    D) DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";;
    h) usage; exit;;
    \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
    :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
esac
done

if [[ $DIR = "" ]]
# if ! $DIR && [[ -d $1 ]]
then
    echo "Directory is not set, use flag -f with a path to a folder"
    # echo "-r or -R must be included when a directory is specified" >&2
    exit 1
fi

if $v; then
    echo "Executing dry run..."
fi

spacecheck () {
    if $v; then
        echo "checking directory: $1"
        echo "Checking for spaces in filenames..."
        findspaces $1
    else
        # replace spaces with underscores
        echo "Replacing spaces in filenames..."
        fixspaces $1
        # for file in $(find $d -type f -name "* *"); do mv "$file" `echo $file | tr ' ' '_'` ; done
    fi
}

shopt -s globstar

for d in $DIR/**/; do
    [[ ! -d $d ]] && continue # if not directory then skip

    # echo $d 
    
    i=1;

    spacecheck $d

    # echo $'Files:\n'$files$'\n\n'
    echo "Renaming files to match folder name..."
    files=`ls -v $d/*.* 2>/dev/null`
    # if [ ${#files[@]} -gt 0 ]; then 
        for f in $files; do
        # [[ -d $d ]] && continue # if directory then skip
        pad=$(printf "%04d" $i)
        dirname=$(dirname "$f")
        result="${dirname%"${dirname##*[!/]}"}" # extglob-free multi-trailing-/ trim
        result="${result##*/}"                  # remove everything before the last /
        if $v; then
            b=$(basename $f)
            echo "existing file: $b --> ${result}_${pad}.${f##*.}"
        else
            # echo "existing file: $f --> ${result}_${pad}.${f##*.}"
            mv -v "$f" "$dirname/${result}_${pad}.${f##*.}";
        fi
        ((i++));
        done;

        spacecheck $d
    # fi
done

shopt -u globstar