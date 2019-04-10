#!/bin/bash

shopt -s globstar

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ffmpeg=(${DIR}/ffmpeg/bin/ffmpeg.exe)
# $ffmpeg -y -i ./output/tessemote_2048.webm -i nasa_moon_nobg_512.png -filter_complex "overlay='-w+(200*(t+1))':(main_h-overlay_h)/2" -vcodec libvpx -b:v 10M -qmin 0 -qmax 10 -crf 0 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -auto-alt-ref 0 tessemote_2048_moon2.webm
$ffmpeg -y -i ./output/tessemote_2048.webm -i nasa_moon_nobg_512.png \
    -filter_complex " \
        [0:v]setpts=PTS-STARTPTS, scale=2048x2048[top]; \
        [1:v]setpts=PTS-STARTPTS, scale=512x512, \
             format=yuva420p,colorchannelmixer=aa=0.5[bottom]; \
        [top][bottom]overlay=shortest=1" \
-vcodec libvpx tessemote_2048_moon3.webm
# $ffmpeg -y -i ./output/tessemote_2048.webm -i nasa_moon_nobg_512.png -filter_complex "overlay=10:10" -vcodec libvpx -b:v 10M -qmin 0 -qmax 10 -crf 0 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -auto-alt-ref 0 tessemote_2048_moon.webm

shopt -u globstar