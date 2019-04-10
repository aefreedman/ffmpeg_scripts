#!/bin/sh

echo "Running FFMPEG"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FOLDER=$1
FILES=$2
$DIR\\ffmpeg\\bin\\ffmpeg.exe -r 30 -f image2 -i $DIR\\sources\\$FOLDER\\$FILES.png -vcodec libvpx -b:v 10M -qmin 0 -qmax 10 -crf 0 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -auto-alt-ref 0 .\\output\\${FOLDER,,}.webm