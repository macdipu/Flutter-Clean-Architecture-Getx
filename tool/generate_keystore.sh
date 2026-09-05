#!/usr/bin/env bash
# Reads android/key.properties (storePassword, keyPassword, keyAlias, storeFile)
# and generates a matching release keystore if one doesn't already exist there.
# Never overwrites silently - an existing file at storeFile is renamed aside
# with a timestamp first, since replacing a keystore that has ever signed a
# Play Store upload permanently breaks future updates.
#
# Usage: bash tool/generate_keystore.sh
set -euo pipefail
cd "$(dirname "$0")/.."

PROPS="android/key.properties"
[ -f "$PROPS" ] || { echo "android/key.properties not found" >&2; exit 1; }

get() { grep "^$1=" "$PROPS" | head -1 | cut -d= -f2-; }

STORE_PASSWORD=$(get storePassword)
KEY_PASSWORD=$(get keyPassword)
KEY_ALIAS=$(get keyAlias)
STORE_FILE=$(get storeFile)

if [ -z "$STORE_PASSWORD" ] || [ -z "$KEY_ALIAS" ] || [ -z "$STORE_FILE" ]; then
  echo "key.properties is missing storePassword/keyAlias/storeFile" >&2
  exit 1
fi

if [ "$STORE_PASSWORD" != "$KEY_PASSWORD" ]; then
  echo "storePassword and keyPassword must match (PKCS12 keystores don't support separate passwords)" >&2
  exit 1
fi

if [ -e "$STORE_FILE" ]; then
  backup="${STORE_FILE}.$(date +%Y%m%d%H%M%S).bak"
  mv "$STORE_FILE" "$backup"
  echo "Existing keystore backed up to $backup"
fi

mkdir -p "$(dirname "$STORE_FILE")"

keytool -genkeypair -v \
  -keystore "$STORE_FILE" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -storepass "$STORE_PASSWORD" \
  -dname "CN=Habitly, OU=Habitly, O=macdipu, L=Unknown, ST=Unknown, C=US"

echo "Keystore written to $STORE_FILE (alias: $KEY_ALIAS)"
