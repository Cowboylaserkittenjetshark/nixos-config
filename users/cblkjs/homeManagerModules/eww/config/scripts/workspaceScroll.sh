#!/bin/bash
if [[ "$1" == "up" ]]; then
  hyprctl dispatch workspace e+1
else
  hyprctl dispatch workspace e-1
fi
