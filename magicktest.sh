#!/bin/bash

magick="./magick/ImageMagick/magick.exe"
moon="./nasa_moon_nobg.png"

# echo ${name}

source=""
output="./output/"
verify=false
dim=""

usage () {
    echo "help empty"
}

while getopts s:vhd: opt; do
[[ ${OPTARG} == -* ]] && { echo "Missing argument for -${opt}" ; exit 1 ; }
case "${opt}"
in
    v) v=true;;
    s) source=${OPTARG};;
    h) usage; exit;;
    d) dim=${OPTARG};;
    \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
    :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
esac
done

if [[ $source = "" ]]
then
    echo "Source file unset, set with -s"
    exit 1
fi

name=${source##*/}
name=${name%.*}

doMagick () {
    $magick logo: logo.gif
    $magick identify logo.gif
    $magick logo.gif win:
}

crop () {
    $magick convert $source -gravity center -crop 2048x2048+0+0 +repage -set filename:area '%wx%h' $output$name'_%[filename:area].png'
    # $magick identify moon.png
    # $magick moon.png win:
    # $magick convert
}

resize () {
    $magick convert $source -resize 512x512 $name'_512.png'
}

resizeUnsharp () {
    $magick convert $source -resize 512x512 -unsharp 1x5x1+0.7+0.02 $output$name'_512_unsharp.png'
}

compare () {
    $magick compare -verbose -metric PSNR -compose src $name'_512.png' $name'_512_unsharp.png' $output$name'_difference.png'
}

compare2 () {
    local comparename = $(basename $image_a)"_vs_"$(basename $image_b)
    $magick compare -verbose -metric PSNR -compose src $image_a $image_b $comparename.png
}

splitSprites () {
    if [[ $dim = "" ]]
    then
        echo "dimensions unset, set with -d"
        exit 1
    fi
    $magick convert $source -crop $dim $output$name'_%04d.png'
}

# resize
# resizeUnsharp
# compare
# compare2
splitSprites