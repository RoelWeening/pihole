#!/bin/bash

# Wait for gravity.db to be ready
until [ -f /etc/pihole/gravity.db ]; do
  echo "Waiting for gravity.db to be created..."
  sleep 2
done

# Import adlists
if [ -f /etc/pihole/adlists.list ]; then
  echo "Importing adlists..."
  while IFS= read -r adlist
  do
    sqlite3 /etc/pihole/gravity.db "INSERT OR IGNORE INTO adlist (address, enabled) VALUES ('$adlist', 1);"
  done < /etc/pihole/adlists.list
fi

# Update gravity database
pihole -g
