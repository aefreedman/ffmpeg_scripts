#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ffmpeg=(${DIR}/ffmpeg/bin/ffmpeg.exe)
source=(./sources)
output=(./output)
verify=false

while getopts s:o:v option # add : after flag if flag is required
do
case "${option}"
in
s) source=${OPTARG};;
o) output=${OPTARG};;
v) verify=true;;
esac
done

if $verify; then
    echo "source: $source"
fi

for d in ${source}/*/
do
    # echo "${d}"
    # dirname=$(dirname "$d")
    basename=$(basename "$d")
    finaloutput="${output}/${basename,,}.webm"
    if $verify; then
        echo "finalout: $finaloutput"
    else
        ${ffmpeg} -y -r 30 -f image2 -i "${d}/${basename}_%04d.png" -vcodec libvpx -b:v 10M -qmin 0 -qmax 10 -crf 0 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -auto-alt-ref 0 "${finaloutput}"
    fi
done