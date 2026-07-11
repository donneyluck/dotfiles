#!/bin/bash
# workspaces.sh - text-only highlight for 9 separate ws items
# Focused: Catppuccin Lavender (0xffb4befe), Unfocused: dim (0xff585b70)

WS_ICONS[1]=""
WS_ICONS[2]=""
WS_ICONS[3]=""
WS_ICONS[4]=""
WS_ICONS[5]=""
WS_ICONS[6]=""
WS_ICONS[7]=""
WS_ICONS[8]=""
WS_ICONS[9]=""

WS_NAMES[1]="term"
WS_NAMES[2]="code"
WS_NAMES[3]="web"
WS_NAMES[4]="chat"
WS_NAMES[5]="file"
WS_NAMES[6]="tool"
WS_NAMES[7]="obsidian"
WS_NAMES[8]="game"
WS_NAMES[9]="sunflower"

CURRENT=$(yabai -m query --spaces --display | jq '.[] | select(."has-focus" == true) | .index')

for i in $(seq 1 9); do
  ICON="${WS_ICONS[$i]}"
  NAME="${WS_NAMES[$i]}"
  if [ "$i" = "$CURRENT" ]; then
    sketchybar --set ws_$i label="${ICON} ${NAME}" label.color=0xffb4befe
  else
    sketchybar --set ws_$i label="${ICON} ${NAME}" label.color=0xff585b70
  fi
done
