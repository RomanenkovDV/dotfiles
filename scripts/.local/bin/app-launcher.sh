#!/usr/bin/env bash

CACHE_DLM=$'\t'
CACHE_FILE="$HOME/.cache/fzf_app_launcher.cache"

update_cache() {
    local search_paths=(
        "/usr/share/applications/"
        "$HOME/.local/share/applications/"
        #"/var/lib/flatpak/exports/share/applications/"
    )
    find -L "${search_paths[@]}" -type f -name "*.desktop" 2>/dev/null | \
    while read -r file; do
      name=$(grep -m1 "^Name=" "$file" | cut -d= -f2)
      categories=$(grep -m1 "^Categories=" "$file" | cut -d= -f2 || echo "Uncategorized")
      echo "$name - (${categories%;})$CACHE_DLM$file"
    done > "$CACHE_FILE.tmp"
    mv "$CACHE_FILE.tmp" "$CACHE_FILE"
}

if [[ ! -f "$CACHE_FILE" ]]; then
    update_cache
else
    (update_cache &) &>/dev/null
fi

FZF_RESULT=$(cat "$CACHE_FILE" | fzf \
  --exact \
  --print-query \
  --layout=reverse \
  --prompt="launch: " \
  --delimiter="$CACHE_DLM" \
  --with-nth=1 \
  --preview='grep -E "^Name=|^Comment=|^Exec=|^Path=|^Categories=" {2}' \
  --preview-window=right:50%:wrap \
  --bind "ctrl-j:print-query" \
)

echo $FZF_RESULT

QUERY=$(echo "$FZF_RESULT" | head -n 1)
SELECTION=$(echo "$FZF_RESULT" | tail -n +2)

if [[ -n "$SELECTION" ]]; then
    APP_PATH=$(echo "$SELECTION" | cut -d=$CACHE_DLM -f2)
    swaymsg -t command exec "gtk-launch $(basename "$APP_PATH")"
else
    swaymsg -t command exec "$QUERY"
fi
