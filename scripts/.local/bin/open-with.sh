#!/bin/bash

if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Использование: open-with <файл>"
    exit 1
fi

FILE="$1"
MIMETYPE=$(xdg-mime query filetype "$FILE")
APPS=$(xdg-mime query default "$MIMETYPE" 2>/dev/null)

if [ -z "$APPS" ]; then
    APPS=$(grep -l "$MIMETYPE" /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null | xargs -I{} basename {})
fi

DEFAULT_APPS="firefox.desktop nautilus.desktop gedit.desktop"
APPS=$(echo -e "$APPS\n$DEFAULT_APPS" | sort -u)

SELECTED_APP=$(echo "$APPS" | fzf --height 40% --reverse --prompt="Выберите приложение для '$FILE' (MIME: $MIMETYPE): ")

if [ -n "$SELECTED_APP" ]; then
    xdg-open "$FILE" 2>/dev/null || gtk-launch "${SELECTED_APP%.desktop}" "$FILE"
else
    echo "Приложение не выбрано."
fi
