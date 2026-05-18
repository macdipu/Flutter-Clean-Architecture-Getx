#!/bin/bash

# Kill any running emulator instances before starting a new one
pkill -f "/opt/android-sdk/emulator/emulator"

# Removes .lock files before emulator starts to prevent crashes
rm -rf /data/android.avd/*.lock

# Use custom ramdisk if present
if [ -f /data/android.avd/ramdisk.img ]; then
  RAMDISK="-ramdisk /data/android.avd/ramdisk.img"
fi

# Path to the AVD config
CONFIG_FILE="/data/android.avd/config.ini"

update_config() {
  local key="$1"
  local value="$2"
  if grep -q "^$key=" "$CONFIG_FILE"; then
    sed -i "s/^$key=.*/$key=$value/" "$CONFIG_FILE"
  else
    echo "$key=$value" >> "$CONFIG_FILE"
  fi
}

# Configure optional screen resolution and density directly via config.ini
if [ -f "$CONFIG_FILE" ]; then
  if [ -n "$SCREEN_RESOLUTION" ]; then
    WIDTH=${SCREEN_RESOLUTION%x*}
    HEIGHT=${SCREEN_RESOLUTION#*x}
    update_config "hw.lcd.width" "$WIDTH"
    update_config "hw.lcd.height" "$HEIGHT"
  fi
  if [ -n "$SCREEN_DENSITY" ]; then
    update_config "hw.lcd.density" "$SCREEN_DENSITY"
  fi
fi

# Start the emulator with the appropriate ramdisk.img
/opt/android-sdk/emulator/emulator_bin() {
  /opt/android-sdk/emulator/emulator
}

# Choose accelerator flags depending on whether /dev/kvm is available in the container.
# Falling back to software accel (-accel off) on hosts without KVM avoids crashes in
# environments that don't support nested virtualization.
EMULATOR_FLAGS=( -avd android -nojni -netfast -writable-system -no-window -no-audio -no-boot-anim -skip-adb-auth -gpu swiftshader_indirect -no-snapshot -no-metrics $RAMDISK -qemu -m ${RAM_SIZE:-2048} )

if [ -c /dev/kvm ]; then
  # Prefer hardware accel when available
  EMULATOR_FLAGS+=( -accel on )
else
  # Force software acceleration when /dev/kvm is not present
  EMULATOR_FLAGS+=( -accel off )
fi

# Execute emulator with chosen flags
/opt/android-sdk/emulator/emulator "${EMULATOR_FLAGS[@]}"
