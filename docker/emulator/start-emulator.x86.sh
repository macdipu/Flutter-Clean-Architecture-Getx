#!/usr/bin/env bash
set -euo pipefail

ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-/opt/android-sdk}
EMULATOR_DIR=${ANDROID_SDK_ROOT}/emulator

# Ensure HOME is set to the android user's home directory used in the image
HOME=${HOME:-/home/android}
AVD_NAME=ci_emulator

# Detect host/container architecture and whether CPU accel is available.
# Use an ABI that will run without requiring /dev/kvm where possible.
HOST_UNAME=$(uname -m || true)
ACCEL_AVAILABLE=0
if [ -c /dev/kvm ]; then
  ACCEL_AVAILABLE=1
fi

# Select preferred system image ABI:
# - If we have KVM and host is x86_64, prefer x86_64 system image (fast)
# - Else prefer arm64-v8a (more portable, runs on ARM hosts and without KVM)
if [ "$ACCEL_AVAILABLE" -eq 1 ] && [ "$HOST_UNAME" = "x86_64" ]; then
  IMAGE_ABI=x86_64
else
  IMAGE_ABI=arm64-v8a
fi
SYSTEM_IMAGE_ID="system-images;android-33;google_apis;${IMAGE_ABI}"

# If the Android SDK root is empty (e.g. a freshly-mounted named volume),
# copy the preinstalled SDK bundle from the image into the volume so the
# runtime has a working SDK. This makes the docker-compose android_sdk
# named volume usable without manual population.
populate_from_bundle() {
  echo "Populating ${ANDROID_SDK_ROOT} from bundled SDK"
  if [ -d "${ANDROID_SDK_ROOT}-bundle" ]; then
    cp -a "${ANDROID_SDK_ROOT}-bundle/." "${ANDROID_SDK_ROOT}/"
    # Ensure sdk ownership is correct for the android user
    chown -R android:android "${ANDROID_SDK_ROOT}" || true
    return 0
  fi
  return 1
}

install_missing_packages() {
  SDKMANAGER_CMD="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager"
  if [ ! -x "$SDKMANAGER_CMD" ]; then
    echo "No sdkmanager in ${ANDROID_SDK_ROOT}; downloading commandline tools to /tmp"
    wget -qO /tmp/cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip \
      && unzip -q /tmp/cmdline-tools.zip -d /tmp/cmdline-tools \
      && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
      && mv /tmp/cmdline-tools/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest/ \
      && rm -rf /tmp/cmdline-tools /tmp/cmdline-tools.zip || true
    SDKMANAGER_CMD="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager"
  fi

  if [ -x "$SDKMANAGER_CMD" ]; then
    echo "Accepting licenses and installing platform-tools + emulator + system image"
    yes | "$SDKMANAGER_CMD" --sdk_root="${ANDROID_SDK_ROOT}" --licenses || true
    # Install the chosen system image ABI (x86_64 or arm64-v8a)
    "$SDKMANAGER_CMD" --sdk_root="${ANDROID_SDK_ROOT}" "platform-tools" "emulator" "$SYSTEM_IMAGE_ID" || true
    chown -R android:android "${ANDROID_SDK_ROOT}" || true
  else
    echo "Warning: sdkmanager not available; ensure the SDK is provided in the android_sdk volume"
  fi
}

# If the Android SDK root is empty (fresh mounted volume), try populate or install
if [ -z "$(ls -A ${ANDROID_SDK_ROOT} 2>/dev/null || true)" ]; then
  if ! populate_from_bundle; then
    echo "SDK bundle not found in image; attempting to install into ${ANDROID_SDK_ROOT}"
    install_missing_packages
  fi
fi

# If required components are missing in the mounted SDK, attempt to install them
MISSING=0
if [ ! -x "${ANDROID_SDK_ROOT}/platform-tools/adb" ]; then
  echo "platform-tools missing in ${ANDROID_SDK_ROOT}"
  MISSING=1
fi
if [ ! -x "${ANDROID_SDK_ROOT}/emulator/emulator" ]; then
  echo "emulator binary missing in ${ANDROID_SDK_ROOT}"
  MISSING=1
fi
if [ ! -d "${ANDROID_SDK_ROOT}/system-images" ]; then
  echo "system-images missing in ${ANDROID_SDK_ROOT}"
  MISSING=1
fi
if [ "$MISSING" -eq 1 ]; then
  echo "Installing missing SDK packages into ${ANDROID_SDK_ROOT}"
  install_missing_packages
fi

# Ensure home and .android ownership are usable by the android user (mounted volumes
# can be root-owned). Do this before creating/using AVDs and before starting emulator.
chown -R android:android "$HOME" || true
chown -R android:android "${ANDROID_SDK_ROOT}" || true

# Create AVD if not exists
if [ ! -d "$HOME/.android/avd/${AVD_NAME}.avd" ]; then
  echo "Creating AVD $AVD_NAME (ABI: ${IMAGE_ABI})"
  # Ensure .android exists and is owned by the android user (mounted volume may be root-owned)
  mkdir -p "$HOME/.android/avd"
  chown -R android:android "$HOME/.android" || true
  # Remove any previous AVD files to avoid ABI mismatches
  rm -rf "$HOME/.android/avd/${AVD_NAME}.avd" "$HOME/.android/avd/${AVD_NAME}.ini" || true
  # Create AVD forcing the specific system image and ABI
  echo "no" | "${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/avdmanager" create avd -n "${AVD_NAME}" -k "$SYSTEM_IMAGE_ID" --abi "$IMAGE_ABI" -d pixel --force || true
  chown -R android:android "$HOME/.android" || true
fi

# Start virtual display for GUI interaction
Xvfb :0 -screen 0 1280x720x24 &
export DISPLAY=:0
sleep 2

# Start VNC server for remote access
x11vnc -display :0 -nopasswd -forever -bg &

echo "Starting emulator (trying multiple compatibility flags until one runs)..."

# Emulator flags attempts (ordered from fastest to most compatible)
EMULATOR_ATTEMPTS=(
  "-no-audio -no-boot-anim -gpu swiftshader_indirect -verbose"
  "-no-audio -no-boot-anim -gpu swiftshader -verbose"
  "-no-audio -no-boot-anim -accel off -gpu swiftshader -verbose"
  "-no-audio -no-boot-anim -accel off -gpu host -verbose"
)

LOG_FILE="$HOME/emulator.log"
rm -f "$LOG_FILE" || true

start_emulator_with_flags() {
  local flags="$1"
  echo "Attempt: starting emulator with flags: $flags"
  # Start as the android user so AVD and HOME are correct
  su - android -c "export ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT} ANDROID_SDK_HOME=${HOME} ANDROID_AVD_HOME=${HOME}/.android/avd HOME=${HOME}; \"${EMULATOR_DIR}/emulator\" -avd ${AVD_NAME} $flags > ${LOG_FILE} 2>&1 & echo \$!"
}

EMULATOR_PID=""
for flags in "${EMULATOR_ATTEMPTS[@]}"; do
  EMULATOR_PID=$(start_emulator_with_flags "$flags" || true)
  # Give it a short warmup
  sleep 5
  # Check if process exists
  if [ -n "$EMULATOR_PID" ] && docker_pid_ok=1; then
    # su returns the PID printed; verify that PID exists in process table
    if ps -p "$EMULATOR_PID" >/dev/null 2>&1; then
      echo "Emulator process started (pid $EMULATOR_PID), waiting for device..."
      # Wait for device up to 120s
      for j in {1..40}; do
        sleep 3
        # restart adb server to ensure fresh
        "${ANDROID_SDK_ROOT}/platform-tools/adb" kill-server || true
        "${ANDROID_SDK_ROOT}/platform-tools/adb" start-server || true
        if "${ANDROID_SDK_ROOT}/platform-tools/adb" devices -l | awk 'NR>1 && NF{print $1; exit}' >/dev/null 2>&1; then
          echo "Device detected via adb"
          echo "Forwarding adb to host via tcp:5555"
          "${ANDROID_SDK_ROOT}/platform-tools/adb" tcpip 5555 || true
          echo "Emulator started successfully with flags: $flags"
          break 2
        fi
        # also check boot property
        BOOTC=$("${ANDROID_SDK_ROOT}/platform-tools/adb" shell getprop sys.boot_completed 2>/dev/null || echo "") || true
        if [ "$BOOTC" = "1" ]; then
          echo "Emulator reports boot completed"
          echo "Forwarding adb to host via tcp:5555"
          "${ANDROID_SDK_ROOT}/platform-tools/adb" tcpip 5555 || true
          break 2
        fi
        echo "Waiting for emulator to boot... ($j/40)"
      done
      # if loop ended without break, emulator didn't boot; kill process and try next flags
      echo "Emulator did not become ready with flags: $flags — stopping and trying next"
      kill "$EMULATOR_PID" >/dev/null 2>&1 || true
      sleep 1
    else
      echo "Emulator process ($EMULATOR_PID) not found after start"
    fi
  else
    echo "Emulator did not start with flags: $flags"
  fi
done

echo "--- Emulator log head (first 200 lines) ---"
sed -n '1,200p' "$LOG_FILE" || true
echo "--- Emulator log tail (last 200 lines) ---"
tail -n 200 "$LOG_FILE" || true

echo "Emulator startup attempts complete. Keeping container running and tailing log."
tail -f "$LOG_FILE"
