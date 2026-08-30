#!/bin/bash

if [ -n "$ROFI_RETV" ] && [ "$ROFI_RETV" = "1" ] && [ -n "$ROFI_INFO" ]; then
    hyprctl dispatch "hl.dsp.focus({window = 'address:$ROFI_INFO'})" > /dev/null 2>&1
    exit 0
fi

hyprctl clients -j | jq -r '.[] | select(.mapped==true) |
    "\(.class)\u0000info\u001f\(.address)\u001ficon\u001f\(.class)"'
