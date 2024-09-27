#!/usr/bin/with-contenv bash
set -e

echo "Importing regex filters..."

if [ -f /etc/pihole/regex.list ]; then
  until [ -f /etc/pihole/gravity.db ]; do
    echo "Waiting for gravity.db to be created..."
    sleep 2
  done

  while IFS= read -r regex; do
    sqlite3 /etc/pihole/gravity.db \
      "INSERT OR IGNORE INTO domainlist (type, domain, enabled) VALUES (3, '$regex', 1);"
  done < /etc/pihole/regex.list
fi
