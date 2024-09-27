#!/usr/bin/with-contenv bash
# Import adlists into gravity database
if [ -f /etc/pihole/adlists.list ]; then
    while read -r adlist; do
        sqlite3 /etc/pihole/gravity.db "INSERT OR IGNORE INTO adlist (address, enabled) VALUES ('$adlist', 1);"
    done < /etc/pihole/adlists.list
fi

# Import regex patterns into gravity database
if [ -f /etc/pihole/regex.list ]; then
    while read -r regex; do
        sqlite3 /etc/pihole/gravity.db "INSERT OR IGNORE INTO domainlist (type, domain, enabled) VALUES (3, '$regex', 1);"
    done < /etc/pihole/regex.list
fi

# Update gravity to apply changes
pihole -g
