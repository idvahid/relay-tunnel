#!/bin/bash

REPO="/root/relay-tunnel"
INBOX="$REPO/inbox"
OUTBOX="$REPO/outbox"

while true
do
    cd "$REPO"
    git pull --no-edit

    for req in $INBOX/*.req; do
        [ -f "$req" ] || continue

        ID=$(basename "$req" .req)

        # ارسال درخواست به SOCKS5 لوکال VPS
        RESPONSE=$(curl --socks5-hostname 127.0.0.1:1080 -s "$(cat $req)")

        echo "$RESPONSE" > "$OUTBOX/$ID.res"

        rm "$req"
    done

    git add .
    git commit -m "relay update" 2>/dev/null
    git push origin main

    sleep 1
done

