#!/usr/bin/env bash
set -e

# Entrypoint for emulator container.
# Responsibilities:
# - start adb
# - optionally start emulator (if ANDROID_EMULATOR_NAME provided)
# - wait for device boot
# - start ws-scrcpy server (if present) to expose scrcpy over websocket

export ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-/opt/android-sdk}
export PATH=${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:${PATH}

AVD_NAME=${ANDROID_EMULATOR_NAME:-}
WS_SCRCPY_DIR=/opt/ws-scrcpy
ANDROID_SYSTEM_IMAGE=${ANDROID_SYSTEM_IMAGE:-}
ANDROID_DEVICE=${ANDROID_DEVICE:-pixel}

log() { echo "[entrypoint] $*"; }

ensure_emulator_tools() {
  if [ ! -x "${ANDROID_SDK_ROOT}/emulator/emulator" ]; then
    log "Emulator binary missing. Installing emulator package..."
    yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true
    sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "emulator" || true
  fi
}

create_avd_if_missing() {
  if [ -z "$AVD_NAME" ]; then
    return 0
  fi
  if [ -d "/home/developer/.android/avd/${AVD_NAME}.avd" ]; then
    return 0
  fi
  log "AVD '$AVD_NAME' not found in /home/developer/.android/avd."
  if [ -z "$ANDROID_SYSTEM_IMAGE" ]; then
    log "Set ANDROID_SYSTEM_IMAGE to auto-create the AVD (example: system-images;android-33;google_apis;x86_64)."
    return 0
  fi

  log "Installing system image: $ANDROID_SYSTEM_IMAGE"
  yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true
  sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "emulator" "$ANDROID_SYSTEM_IMAGE" || true

  log "Creating AVD '$AVD_NAME' with device '$ANDROID_DEVICE'"
  # Use developer user so AVD is created in /home/developer/.android
  su - developer -c "printf 'no\n' | env ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT} ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/avdmanager create avd -n '${AVD_NAME}' -k '${ANDROID_SYSTEM_IMAGE}' --device '${ANDROID_DEVICE}' --force" || true
}

# start adb server
log "Starting adb server..."
adb start-server || true

# Ensure emulator tools are available and create AVD if needed
ensure_emulator_tools
create_avd_if_missing

# If an AVD name is provided, attempt to start the emulator
if [ -n "$AVD_NAME" ]; then
  log "AVD requested: $AVD_NAME"
  # If AVD doesn't exist in ~/.android/avd, warn (user can mount emulator_home with AVDs)
  if [ ! -d "/home/developer/.android/avd/${AVD_NAME}.avd" ]; then
    log "Warning: AVD '$AVD_NAME' not found in /home/developer/.android/avd."
  fi

  log "Starting emulator (headless)..."
  # start emulator in background (no window). Use developer as owner.
  if [ -x "${ANDROID_SDK_ROOT}/emulator/emulator" ]; then
    su - developer -c "${ANDROID_SDK_ROOT}/emulator/emulator -avd '${AVD_NAME}' -no-window -no-audio -gpu swiftshader_indirect -no-boot-anim -wipe-data > /tmp/emulator.log 2>&1 &"
  else
    log "emulator binary not found at ${ANDROID_SDK_ROOT}/emulator/emulator"
  fi
else
  log "No AVD requested. Container will operate with physical devices forwarded or adb connect targets."
fi

# Wait for at least one device to be online
log "Waiting for device..."
# Give adb some time to discover devices/emulator
sleep 2

# wait-for-device is per-device; we'll poll for any device that reports boot completed
BOOT_TIMEOUT=${BOOT_TIMEOUT_SECONDS:-300}
START_TS=$(date +%s)

while true; do
  # list devices
  devices=$(adb devices | sed -n '2,$p' | awk '{print $1" " $2}') || true
  if [ -z "$devices" ]; then
    log "No devices listed yet. Retrying..."
  else
    # check for any device 'device' state and boot completed
    while read -r serial state; do
      [ -z "$serial" ] && continue
      if [ "$state" = "device" ]; then
        # check boot completed property
        boot=$(adb -s "$serial" shell getprop sys.boot_completed 2>/dev/null || echo "0")
        if [ "$boot" = "1" ]; then
          log "Device $serial boot completed."
          DEVICE_SERIAL=$serial
          break 2
        else
          log "Device $serial present but not booted yet."
        fi
      fi
    done <<< "$devices"
  fi
  now=$(date +%s)
  if [ $((now - START_TS)) -gt $BOOT_TIMEOUT ]; then
    log "Timeout waiting for device boot after ${BOOT_TIMEOUT} seconds. Continuing anyway."
    break
  fi
  sleep 2
done

# Optionally enable adb tcpip so scrcpy/ws can connect over network
if [ -n "${DEVICE_SERIAL:-}" ]; then
  log "Enabling adb tcpip on device $DEVICE_SERIAL (5555)..."
  adb -s "$DEVICE_SERIAL" tcpip 5555 || true
fi

# Start ws-scrcpy server if available
if [ -d "$WS_SCRCPY_DIR" ] && [ -f "$WS_SCRCPY_DIR/package.json" ]; then
  log "Starting ws-scrcpy server from $WS_SCRCPY_DIR"
  cd "$WS_SCRCPY_DIR"
  # npm start should be configured by the cloned repo; run as developer
  su - developer -c "cd $WS_SCRCPY_DIR && npm start" &
else
  log "ws-scrcpy not found. If you want websocket scrcpy, mount or clone https://github.com/Shmayro/ws-scrcpy-docker into $WS_SCRCPY_DIR"
fi

# If scrcpy is installed, provide an instruction to the user and keep container alive
if command -v scrcpy >/dev/null 2>&1; then
  log "scrcpy is installed in the image. To open interactive mirror from the host, run scrcpy locally and connect to this container's adb (e.g. adb connect <container_ip>:5555) or use ws-scrcpy server if configured."
fi

log "Container setup complete. Tailing logs to keep container running."
# Tail emulator logs if present otherwise sleep
if [ -f /tmp/emulator.log ]; then
  tail -n +1 -f /tmp/emulator.log &
fi

# Keep PID(s) alive
wait

