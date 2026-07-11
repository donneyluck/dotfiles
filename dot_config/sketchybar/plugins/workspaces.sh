#!/bin/bash

# Workspace display - text-only highlight
# Focused: Catppuccin Lavender (elegant, not harsh white)
# Unfocused: dim gray

WS_ICONS[1]=""
WS_ICONS[2]=""
WS_ICONS[3]=""
WS_ICONS[4]=""
WS_ICONS[5]=""
WS_ICONS[6]=""
WS_ICONS[7]=""
WS_ICONS[8]=""
WS_ICONS[9]=""

WS_NAMES[1]="TERMINAL"
WS_NAMES[2]="CODE"
WS_NAMES[3]="BROWSER"
WS_NAMES[4]="CHAT"
WS_NAMES[5]="FILE"
WS_NAMES[6]="TOOLS"
WS_NAMES[7]="OBSIDIAN"
WS_NAMES[8]="GAME"
WS_NAMES[9]="SUNFLOWER"

CURRENT=$(yabai -m query --spaces --display | jq '.[] | select(."has-focus" == true) | .index')

for i in $(seq 1 9); do
  ICON="${WS_ICONS[$i]}"
  NAME="${WS_NAMES[$i]}"
  if [ "$i" = "$CURRENT" ]; then
    sketchybar --set ws_$i label="${ICON} ${NAME}" \
                             label.color=0xffb4befe
  else
    sketchybar --set ws_$i label="${ICON} ${NAME}" \
                             label.color=0xff585b70
  fi
done