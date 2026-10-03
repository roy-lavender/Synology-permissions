#!/bin/bash

MODE="$1"

WEB_ROOT="/volume1/web"
INDEX_FILE="$WEB_ROOT/index.html"
BACKUP_FILE="$WEB_ROOT/index.html.bak"

enable_status_page() {
    echo "Enabling status page..."

    # Backup original index if it exists
    if [ -f "$INDEX_FILE" ] && [ ! -f "$BACKUP_FILE" ]; then
        cp "$INDEX_FILE" "$BACKUP_FILE"
    fi

    cat <<EOF > "$INDEX_FILE"
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="refresh" content="0; url=/status.html">
</head>
<body>
    Redirecting to status page...
</body>
</html>
EOF

    echo "Status page ENABLED."
}

disable_status_page() {
    echo "Restoring normal login..."

    # Restore original index if backup exists
    if [ -f "$BACKUP_FILE" ]; then
        mv "$BACKUP_FILE" "$INDEX_FILE"
    else
        rm -f "$INDEX_FILE"
    fi

    echo "Status page DISABLED."
}

case "$MODE" in
    start)
        enable_status_page
        ;;
    stop)
        disable_status_page
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
