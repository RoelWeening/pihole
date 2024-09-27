#!/bin/bash

# Wait for gravity.db to be ready
until [ -f /etc/pihole/gravity.db ]; do
  echo "Waiting for gravity.db to be created..."
  sleep 2
done

# Import regex filters
if [ -f /etc/pihole/regex.list ]; then
  echo "Importing regex filters..."
  while IFS= read -r regex
  do
    sqlite3 /etc/pihole/gravity.db "INSERT OR IGNORE INTO domainlist (type, domain, enabled) VALUES (3, '$regex', 1);"
  done < /etc/pihole/regex.list
fi

# Restart Pi-hole DNS
pihole restartdns
