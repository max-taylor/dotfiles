#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on background.color=0xff81a1c1
else
    sketchybar --set $NAME background.drawing=off background.color=0xff57627A
fi
