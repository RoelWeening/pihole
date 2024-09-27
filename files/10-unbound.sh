#!/usr/bin/with-contenv bash
set -e

# Initialize root key if not present
if [ ! -f /var/lib/unbound/root.key ]; then
  echo "Initializing Unbound root trust anchor..."
  unbound-anchor -a "/var/lib/unbound/root.key" || true
fi
