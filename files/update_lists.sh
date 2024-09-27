#!/bin/bash

# URLs of remote hosts lists and regex filters
ADLISTS_URL="https://example.com/adlists.list"
REGEXLIST_URL="https://example.com/regex.list"

# Download and update adlists
curl -sSL "$ADLISTS_URL" -o /etc/pihole/adlists.list

# Download and update regex filters
curl -sSL "$REGEXLIST_URL" -o /etc/pihole/regex.list

# Update gravity database
pihole -g

# Start Pi-hole
exec /s6-init
