#!/bin/bash

# ===== CONFIG =====
DEFAULT_MESSAGE="⚠️ Maintenance in progress"
EMPTY_MESSAGE=""

# ===== FUNCTIONS =====

set_login_message() {
    local msg="$1"
    echo "Setting DSM login message..."

    synosetkeyvalue /usr/syno/etc/preference/System/login_style login_welcome_msg "$msg"

    # Restart DSM web service (newer DSM versions)
    if command -v synosystemctl >/dev/null 2>&1; then
        synosystemctl restart nginx
    else
        /usr/syno/bin/synosystemctl restart nginx
    fi
}

start_message() {
    local custom_msg="$1"

    if [ -z "$custom_msg" ]; then
        MESSAGE="$DEFAULT_MESSAGE"
    else
        MESSAGE="$custom_msg"
    fi

    set_login_message "$MESSAGE"
    echo "Login message set."
}

stop_message() {
    echo "Clearing login message..."
    set_login_message "$EMPTY_MESSAGE"
    echo "Login message cleared."
}

# ===== MAIN =====

case "$1" in
    start)
        shift
        start_message "$*"
        ;;
    stop)
        stop_message
        ;;
    *)
        echo "Usage:"
        echo "  $0 start [custom message]"
        echo "  $0 stop"
        exit 1
        ;;
esac
