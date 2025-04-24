#!/usr/bin/env bash

# Путь к кэшу
CACHE_FILE="$HOME/.cache/fzf_app_launcher.cache"

# Функция обновления кэша в фоне
update_cache() {
    # Ищем .desktop-файлы, извлекаем названия и пути
    find /usr/share/applications/ ~/.local/share/applications/ -type f -name "*.desktop" 2>/dev/null | \
    while read -r file; do
        grep -m1 "^Name=" "$file" | cut -d= -f2 | tr -d '\n'
        echo "|$file"
    done > "$CACHE_FILE.tmp"
    mv "$CACHE_FILE.tmp" "$CACHE_FILE"
}

# Если кэша нет — создаём сразу
if [[ ! -f "$CACHE_FILE" ]]; then
    update_cache
else
    # Иначе обновляем в фоне (чтобы не блокировать запуск)
    (update_cache &) &>/dev/null
fi

# Запускаем fzf на актуальных данных (из кэша)
SELECTION=$(cat "$CACHE_FILE" | fzf --layout=reverse --prompt="launch: ")
if [[ -n "$SELECTION" ]]; then
    APP_PATH=$(echo "$SELECTION" | cut -d'|' -f2)
    swaymsg -t command exec "gtk-launch $(basename "$APP_PATH")"
fi
