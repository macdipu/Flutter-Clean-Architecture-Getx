#!/usr/bin/env bash
set -euo pipefail

# New entrypoint uses supervisord to manage first-boot and emulator processes
if [ "$1" = "--supervisor" ] || [ "$#" -eq 0 ]; then
  echo "[entrypoint] Starting supervisord"
  exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
fi

exec "$@"
