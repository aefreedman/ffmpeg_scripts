#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ffmpeg=(${DIR}/ffmpeg/bin/ffmpeg.exe)
source=(./sources)
output=(./output)
verify=false
reverse=false

while getopts s:o:vr option # add : after flag if flag is required
do
case "${option}"
in
s) source=${OPTARG};;
o) output=${OPTARG};;
v) verify=true;;
r) reverse=true;;
esac
done

if $verify; then
    echo "source: $source"
fi

shopt -s globstar

for d in $source/**/; do
    [[ ! -d $d ]] && continue # if not directory then skip
    # echo "${d}"
    # dirname=$(dirname "$d")
    basename=$(basename "$d")
    finaloutput="${output}/${basename,,}.webm"
    finaloutputreverse="${output}/${basename,,}_reverse.webm"
    if $verify; then
        echo "finalout: $finaloutput"
        if $reverse; then
        echo "finalout: $finaloutputreverse"
        fi
    else
    #-vf scale=512x512
        ${ffmpeg} -y -r 30 -f image2 -i "${d}/${basename}_%04d.png" -vcodec libvpx -b:v 10M -qmin 0 -qmax 10 -crf 0 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -auto-alt-ref 0 "${finaloutput}"
        if $reverse; then
                ${ffmpeg} -y -r 30 -f image2 -i "${d}/${basename}_%04d.png" -vcodec libvpx -b:v 10M -qmin 0 -qmax 10 -crf 0 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -vf reverse -auto-alt-ref 0 "${finaloutputreverse}"
        fi
    fi
done

shopt -u globstar