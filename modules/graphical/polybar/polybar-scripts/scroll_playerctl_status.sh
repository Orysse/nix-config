#!/bin/sh

# see man zscroll for documentation of the following parameters
zscroll -l 37 \
        --delay 0.2 \
        --scroll-padding "  " \
        --match-command "`dirname $0`/get_playerctl_status.sh --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check true "`dirname $0`/get_playerctl_status.sh" &

wait
sleep 2
