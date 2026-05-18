#!/usr/bin/env bash
set -euo pipefail

ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-/opt/android-sdk}
AVD_NAME=${ANDROID_EMULATOR_NAME:-android_emulator}

log() { echo "[emulator-runner] $*"; }

if [ ! -x "${ANDROID_SDK_ROOT}/emulator/emulator" ]; then
  log "emulator binary not found"
  exit 1
fi

if [ ! -d "/home/developer/.android/avd/${AVD_NAME}.avd" ]; then
  log "AVD ${AVD_NAME} missing, exiting"
  exit 1
fi

log "Starting emulator ${AVD_NAME}"
su - developer -c "${ANDROID_SDK_ROOT}/emulator/emulator -avd '${AVD_NAME}' -no-window -no-audio -gpu swiftshader_indirect -no-boot-anim -wipe-data > /tmp/emulator.log 2>&1 &"

# Wait for emulator log to appear and tail it to stdout
while [ ! -f /tmp/emulator.log ]; do
  sleep 1
done
tail -n +1 -f /tmp/emulator.log
