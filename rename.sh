#!/bin/sh

v=false
DIR=""

usage () { echo "How to use"; }

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

for d in $DIR/*/; do
    i=1;
    if $v; then
        echo "checking directory: ${d}"
    fi
    for f in "$d"/*.*; do
        pad=$(printf "%04d" $i)
        dirname=$(dirname "$f")
        result="${dirname%"${dirname##*[!/]}"}" # extglob-free multi-trailing-/ trim
        result="${result##*/}"                  # remove everything before the last /
        if $v; then
            b=$(basename $f)
            echo "existing file: $b --> ${result}_${pad}.${f##*.}"
        else
            mv -- "$f" "$dirname/${result}_${pad}.${f##*.}";
        fi
        # mv -- "$f" "$d${d%/}_${pad}.${f##*.}";
        ((i++));
    done;
done