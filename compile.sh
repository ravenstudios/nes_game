#!/usr/bin/env bash

o_file=${1%.*}.o
nes_file=${1%.*}.nes

cc65/bin/ca65 $1 -o $o_file -t nes  || exit 1
cc65/bin/ld65 $o_file -o $nes_file -t nes  || exit 1

rm $o_file

/Applications/Mesen.app/Contents/MacOS/Mesen $nes_file
