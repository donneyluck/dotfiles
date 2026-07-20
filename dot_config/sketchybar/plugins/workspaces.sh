#!/bin/bash

# Workspace display - text-only highlight
# Focused: Catppuccin Lavender (elegant, not harsh white)
# Unfocused: dim gray
# Emoji icons + friendly names (方案 B: 仅改内容，保留配色)

WS_ICONS[1]="👻"
WS_ICONS[2]="💻"
WS_ICONS[3]="🌐"
WS_ICONS[4]="💬"
WS_ICONS[5]="🗃️"
WS_ICONS[6]="🔧"
WS_ICONS[7]="📚"
WS_ICONS[8]="📊"
WS_ICONS[9]="🌻"

WS_NAMES[1]="Ghostty"
WS_NAMES[2]="Code"
WS_NAMES[3]="Browser"
WS_NAMES[4]="Chat"
WS_NAMES[5]="File"
WS_NAMES[6]="Tools"
WS_NAMES[7]="Obsidian"
WS_NAMES[8]="Media"
WS_NAMES[9]="Sunflower"

CURRENT=$(yabai -m query --spaces --display | python3 -c "import sys,json; d=json.load(sys.stdin); print([s['index'] for s in d if s.get('has-focus')][0])")

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
