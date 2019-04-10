#!/bin/bash

shopt -s globstar

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ffmpeg=(${DIR}/ffmpeg/bin/ffmpeg.exe)
rm mylist.txt
for f in ./output/**.webm; do echo "file '$f'" >> mylist.txt; done
$ffmpeg -y -f concat -safe 0 -i mylist.txt -vcodec libvpx -b:v 10M -qmin 0 -qmax 10 -crf 0 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -auto-alt-ref 0 -c copy output.webm
$ffmpeg -y -i output.webm -i letterhead_small.png -filter_complex "overlay=10:10" -vcodec libvpx -b:v 10M -qmin 0 -qmax 10 -crf 0 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -auto-alt-ref 0 output_wm.webm
# $ffmpeg -f concat -safe 0 -i <(find ./output -name '*.webm' -printf "file '$PWD/%p'\n") -c copy output.webm

shopt -u globstar