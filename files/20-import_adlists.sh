#!/usr/bin/with-contenv bash
set -e

echo "Importing adlists..."

if [ -f /etc/pihole/adlists.list ]; then
  until [ -f /etc/pihole/gravity.db ]; do
    echo "Waiting for gravity.db to be created..."
    sleep 2
  done

  while IFS= read -r adlist; do
    sqlite3 /etc/pihole/gravity.db \
      "INSERT OR IGNORE INTO adlist (address, enabled) VALUES ('$adlist', 1);"
  done < /etc/pihole/adlists.list
fi
