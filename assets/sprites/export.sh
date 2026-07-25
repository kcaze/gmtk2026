#!/bin/zsh

alias ase="/Applications/Aseprite.app/Contents/MacOS/aseprite"

ase -b tracks.aseprite --save-as track-{slice}.png
ase -b hourglass_indicator.aseprite --save-as hourglass-indicator-{slice}.png
ase -b soul.aseprite --save-as {slice}.png
