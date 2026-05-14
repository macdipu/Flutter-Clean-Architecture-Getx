#!/usr/bin/env bash
set -euo pipefail

# Ensure cache dirs are writable
mkdir -p /home/developer/.pub-cache /home/developer/.gradle
chown -R developer:developer /home/developer/.pub-cache /home/developer/.gradle || true

exec "$@"
