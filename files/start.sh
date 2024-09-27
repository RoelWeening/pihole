#!/bin/bash
set -e

# Initialize root key if not present
if [ ! -f /var/lib/unbound/root.key ]; then
  echo "Initializing Unbound root trust anchor..."
  unbound-anchor -a "/var/lib/unbound/root.key" || true
fi

# Start Unbound
echo "Starting Unbound..."
/etc/init.d/unbound start

# Update gravity database if required
if [ "$PIHOLE_UPDATE_GRAVITY" = "true" ]; then
  echo "Updating gravity database..."
  pihole -g
fi

# Start Pi-hole
echo "Starting Pi-hole..."
exec /s6-init
