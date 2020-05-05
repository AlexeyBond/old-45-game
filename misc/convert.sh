#!/usr/bin/env bash

magick convert caw-logo-1-1.png -define icon:auto-resize=256,128,84,64,63,60,56,48,47,40,32,31,30,28,24,20,16 icon.ico

mkdir ./android
rm ./android/*

for sz in 48x48 72x72 96x96 144x144 192x192
do
	magick "caw-logo-1-1.png[$sz]" "android/icon-$sz.png"
done;
