#!/bin/bash

MAP_FILE="$HOME/.config/rofi/scripts/icon-map.txt"

if [ -n "$ROFI_RETV" ] && [ "$ROFI_RETV" = "1" ] && [ -n "$ROFI_INFO" ]; then
    hyprctl dispatch "hl.dsp.focus({window = 'address:$ROFI_INFO'})" > /dev/null 2>&1
    exit 0
fi

if [ -n "$ROFI_RETV" ] && [ "$ROFI_RETV" = "3" ] && [ -n "$ROFI_INFO" ]; then
    hyprctl dispatch "hl.dsp.window.close({window = 'address:$ROFI_INFO'})" > /dev/null 2>&1
    exit 0
fi

hyprctl clients -j | jq -r '.[] | select(.mapped==true) | "\(.address)\u001f\(.class)"' | \
while IFS=$'\x1f' read -r address class; do
    mapped=$(grep "^${class}=" "$MAP_FILE" 2>/dev/null)
    if [ -n "$mapped" ]; then
        icon="${mapped#*=}"
        icon="${icon%%|*}"
        display="${mapped#*|}"
    else
        icon="$class"
        display="$class"
    fi
    printf "%s\x00info\x1f%s\x1ficon\x1f%s\n" "$display" "$address" "$icon"
done
