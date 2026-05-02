#!/bin/bash

while true
do
  git pull origin main

  for file in inbox/*.req
  do
    [ -e "$file" ] || continue

    RESPONSE=$(cat "$file")

    echo "Processed: $RESPONSE" > outbox/$(basename "$file" .req).res

    rm "$file"
  done

  git add .
  git commit -m "relay update" 2>/dev/null
  git push origin main

  sleep 2
done

