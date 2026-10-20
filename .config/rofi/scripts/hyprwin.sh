#!/bin/bash

MAP_FILE="$HOME/.config/rofi/scripts/icon-map.txt"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/hyprwin-desktop-map.tsv"
DIRS=(/usr/share/applications "$HOME/.local/share/applications")

if [ "$ROFI_RETV" = "1" ] && [ -n "$ROFI_INFO" ]; then
    hyprctl dispatch "hl.dsp.focus({window = 'address:$ROFI_INFO'})" > /dev/null 2>&1
    exit 0
fi

if [ "$ROFI_RETV" = "3" ] && [ -n "$ROFI_INFO" ]; then
    hyprctl dispatch "hl.dsp.window.close({window = 'address:$ROFI_INFO'})" > /dev/null 2>&1
    exit 0
fi

build_cache() {
    find "${DIRS[@]}" -name '*.desktop' -print0 2>/dev/null | xargs -0 awk '
        function flush() {
            if (icon != "") {
                print tolower(base) "\t" icon
                if (wm != "") print tolower(wm) "\t" icon
            }
        }
        FNR==1 {
            flush()
            n = split(FILENAME, p, "/"); base = p[n]; sub(/\.desktop$/, "", base)
            icon = ""; wm = ""; inentry = 0
        }
        /^\[Desktop Entry\]/ { inentry = 1; next }
        /^\[/ { inentry = 0 }
        inentry && /^Icon=/ && icon == "" { icon = substr($0, 6) }
        inentry && /^StartupWMClass=/ && wm == "" { wm = substr($0, 16) }
        END { flush() }
    '
}

if [ ! -s "$CACHE" ] || [ -n "$(find "${DIRS[@]}" -name '*.desktop' -newer "$CACHE" -print -quit 2>/dev/null)" ]; then
    mkdir -p "$(dirname "$CACHE")"
    build_cache > "$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
fi

declare -A AUTO
while IFS=$'\t' read -r key value; do
    AUTO["$key"]="$value"
done < "$CACHE"

hyprctl clients -j | jq -r '.[] | select(.mapped==true) | "\(.address)\u001f\(.class)"' | \
while IFS=$'\x1f' read -r address class; do
    lc="${class,,}"
    mapped=$(grep -m1 "^${class}=" "$MAP_FILE" 2>/dev/null)
    if [ -n "$mapped" ]; then
        icon="${mapped#*=}"
        icon="${icon%%|*}"
        display="${mapped#*|}"
    else
        display="${class##*.}"; display="${display^}"
        icon="${AUTO[$lc]:-${AUTO[${lc##*.}]:-$class}}"
    fi
    printf "%s\x00info\x1f%s\x1ficon\x1f%s\n" "$display" "$address" "$icon"
done
