#!/usr/bin/env bash
set -euo pipefail

# first-boot.sh: create AVD if missing and install system image
ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-/opt/android-sdk}
AVD_NAME=${ANDROID_EMULATOR_NAME:-android_emulator}
ANDROID_SYSTEM_IMAGE=${ANDROID_SYSTEM_IMAGE:-system-images;android-33;google_apis;x86_64}

log() { echo "[first-boot] $*"; }

ensure_cmdline_tools() {
  if [ ! -x "${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager" ]; then
    log "cmdline tools missing"
    exit 1
  fi
}

create_avd() {
  if [ -d "/home/developer/.android/avd/${AVD_NAME}.avd" ]; then
    log "AVD exists: ${AVD_NAME}"
    return 0
  fi
  log "Installing system image: ${ANDROID_SYSTEM_IMAGE}"
  yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true
  sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "${ANDROID_SYSTEM_IMAGE}" || true

  log "Creating AVD '${AVD_NAME}'"
  su - developer -c "${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/avdmanager create avd -n '${AVD_NAME}' -k '${ANDROID_SYSTEM_IMAGE}' --device 'pixel' --force" || true
}

ensure_cmdline_tools
create_avd

log "first-boot completed"
