#!/usr/bin/env bash
set -euo pipefail

ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-/opt/android-sdk}
EMULATOR_DIR=${ANDROID_SDK_ROOT}/emulator

AVD_NAME=ci_emulator

# If the Android SDK root is empty (e.g. a freshly-mounted named volume),
# copy the preinstalled SDK bundle from the image into the volume so the
# runtime has a working SDK. This makes the docker-compose android_sdk
# named volume usable without manual population.
populate_from_bundle() {
  echo "Populating ${ANDROID_SDK_ROOT} from bundled SDK"
  if [ -d "${ANDROID_SDK_ROOT}-bundle" ]; then
    cp -a ${ANDROID_SDK_ROOT}-bundle/. ${ANDROID_SDK_ROOT}/
    chown -R $(id -u):$(id -g) ${ANDROID_SDK_ROOT} || true
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
    yes | $SDKMANAGER_CMD --sdk_root=${ANDROID_SDK_ROOT} --licenses || true
    $SDKMANAGER_CMD --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "emulator" "system-images;android-33;google_apis;arm64-v8a" || true
    chown -R $(id -u):$(id -g) ${ANDROID_SDK_ROOT} || true
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

# Create AVD if not exists
if [ ! -d "$HOME/.android/avd/${AVD_NAME}.avd" ]; then
  echo "Creating AVD $AVD_NAME"
  echo "no" | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/avdmanager create avd -n ${AVD_NAME} -k "system-images;android-33;google_apis;x86_64" -d pixel || true
fi

# Start adb server
${ANDROID_SDK_ROOT}/platform-tools/adb start-server || true

echo "Starting emulator..."
${EMULATOR_DIR}/emulator -avd ${AVD_NAME} -no-audio -no-boot-anim -gpu swiftshader_indirect -no-window -verbose &

# Wait for device to be online
${ANDROID_SDK_ROOT}/platform-tools/adb wait-for-device

echo "Forwarding adb to host via tcp:5555"
${ANDROID_SDK_ROOT}/platform-tools/adb tcpip 5555 || true

echo "Emulator started. Keeping container running."
wait
