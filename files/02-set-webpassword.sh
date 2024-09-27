#!/usr/bin/with-contenv bash
# File: /etc/cont-init.d/02-set-webpassword.sh

if [[ -n "${WEBPASSWORD}" ]]; then
  echo "Setting custom WEBPASSWORD"
  pihole -a -p "${WEBPASSWORD}" || exit 1
else
  echo "No WEBPASSWORD set; using default password"
fi
