#!/bin/bash

magick="./magick/ImageMagick/magick.exe"

$magick montage "./unsharptest_b/*.png" -trim +repage -geometry +0+0 -background none resizetestb.png
