#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 [command] [args]

Commands:
  up            Build and start services (default)
  connect       Connect flutter container adb to emulator container
  flutter ...   Run a flutter CLI command inside the flutter container
  shell         Open a shell into the flutter container
  help          Show this help message

Examples:
  $0 up
  $0 connect
  $0 flutter pub get
  $0 flutter run -d <device-id>
  $0 shell
EOF
}

cmd=${1:-up}
shift || true

# Emulator mode: auto / container / host
# auto: detect per-host and choose container where sensible, else host
EMULATOR_MODE=${EMULATOR_MODE:-auto}

detect_emulator_mode() {
  if [ "$EMULATOR_MODE" != "auto" ]; then
    return 0
  fi
  HOST_OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  HOST_ARCH=$(uname -m || true)
  if [ "$HOST_OS" = "linux" ] && [ -c /dev/kvm ]; then
    EMULATOR_MODE=container
  elif [ "$HOST_OS" = "darwin" ] && [ "$HOST_ARCH" = "arm64" ]; then
    # On Apple Silicon we can try an arm64 container emulator (experimental)
    EMULATOR_MODE=container
  else
    EMULATOR_MODE=host
  fi
}

detect_emulator_mode

case "$cmd" in
  up)
    echo "Starting docker-compose services..."
    docker compose up --build -d

    EMULATOR_CONTAINER=$(docker compose ps -q emulator || true)
    FLUTTER_CONTAINER=$(docker compose ps -q flutter || true)

    if [ -z "$FLUTTER_CONTAINER" ]; then
      echo "flutter container did not start correctly. Check 'docker compose ps' and logs."
      exit 1
    fi

    echo "Waiting for emulator container to register (if present)..."
    if [ -n "$EMULATOR_CONTAINER" ]; then
      # wait for emulator container adb server to come up
      for i in {1..60}; do
        if docker exec -it $EMULATOR_CONTAINER bash -lc "${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb devices" >/dev/null 2>&1; then
          echo "Emulator container adb present"
          break
        fi
        sleep 1
      done
    fi

    echo "Detecting connected Android devices from within flutter container..."
    # Wait for platform-tools/adb to be present inside flutter container (the emulator may populate the shared android_sdk volume)
    for i in {1..60}; do
      if docker compose exec -u developer flutter bash -lc "test -x ${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb" >/dev/null 2>&1; then
        break
      fi
      echo "Waiting for adb to be available inside flutter container... ($i)"
      sleep 1
    done
    docker compose exec -u developer flutter bash -lc "${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb kill-server; ${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb start-server" || true

    # Try to list devices in flutter container
    docker compose exec -u developer flutter bash -lc "${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb devices -l" || true

    PHONES=$(docker compose exec -u developer flutter bash -lc "${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb devices -l | awk 'NR>1 && NF{print $1,$2,$3,$4}' | sed '/^$/d'" | sed '/^$/d' || true)

    if [ -z "$PHONES" ] && [ -n "$EMULATOR_CONTAINER" ]; then
      # No devices found; attempt to connect to emulator via internal IP
      EMULATOR_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $EMULATOR_CONTAINER)
      echo "No physical devices found. Attempting to connect to emulator at $EMULATOR_IP:5555"
      docker compose exec -u developer flutter bash -lc "${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb connect ${EMULATOR_IP}:5555" || true
      sleep 2
      docker compose exec -u developer flutter bash -lc "${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb devices -l" || true
      PHONES=$(docker compose exec -u developer flutter bash -lc "${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb devices -l | awk 'NR>1 && NF{print $1,$2,$3,$4}' | sed '/^$/d'" | sed '/^$/d' || true)
    fi

    echo
    if [ -z "$PHONES" ]; then
      echo "No Android devices or emulators were detected inside the flutter container."
      echo "You can start the emulator or connect a device. To open a shell into the flutter container run:"
      echo "  $0 shell"
    else
      echo "Detected devices/emulators inside the flutter container:"
      docker compose exec -u developer flutter bash -lc "flutter devices" || true
      echo
      echo "To run on a specific device, use (example):"
      echo "  $0 flutter run -d <device-id>"
    fi

    # Optionally try to connect host adb to the emulator so host tools (Android Studio)
    # can detect the device. Controlled by HOST_ADB_CONNECT (default: enabled if adb present).
    if [ "$EMULATOR_MODE" = "host" ]; then
      echo "EMULATOR_MODE=host detected — attempting to connect to host emulator via host.docker.internal:5555"
      if command -v adb >/dev/null 2>&1; then
        case "${HOST_ADB_CONNECT:-1}" in
          0|false|FALSE|no|NO)
            echo "Skipping host adb connect (HOST_ADB_CONNECT=${HOST_ADB_CONNECT:-1})"
            ;;
          *)
            adb connect host.docker.internal:5555 || adb connect localhost:5555 || true
            echo "Host adb devices:"
            adb devices -l || true
            ;;
        esac
      else
        echo "Host adb not found; please install platform-tools and run: adb connect host.docker.internal:5555"
      fi
    else
      if command -v adb >/dev/null 2>&1; then
        case "${HOST_ADB_CONNECT:-1}" in
          0|false|FALSE|no|NO)
            echo "Skipping host adb connect (HOST_ADB_CONNECT=${HOST_ADB_CONNECT:-1})"
            ;;
          *)
            echo "Attempting to connect host adb to emulator on localhost:5555..."
            adb connect localhost:5555 || true
            echo "Host adb devices:"
            adb devices -l || true
            ;;
        esac
      else
      echo "Host adb not found; skipping host adb connect. If you want host tools to detect the emulator, install adb and re-run: adb connect localhost:5555"
      fi
    fi

    echo
    echo "All services started. You can exec into the flutter container:"
    echo "  $0 shell"
    ;;

  connect)
    # Connect adb from flutter container to emulator container
    EMULATOR_CONTAINER=$(docker compose ps -q emulator || true)
    FLUTTER_CONTAINER=$(docker compose ps -q flutter || true)

    if [ -z "$FLUTTER_CONTAINER" ]; then
      echo "flutter container must be running"
      exit 1
    fi

    if [ -n "$EMULATOR_CONTAINER" ]; then
      EMULATOR_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $EMULATOR_CONTAINER)
      echo "Emulator container found at $EMULATOR_IP. Attempting to connect flutter container adb to it..."
      docker exec -u developer $FLUTTER_CONTAINER ${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb connect ${EMULATOR_IP}:5555 || true
    else
      echo "No emulator container running. If you have a host emulator or a USB device, ensure adb is accessible."
    fi

    echo "Listing devices from flutter container:"
    docker exec -u developer $FLUTTER_CONTAINER ${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb devices -l || true

    DEVICES=$(docker exec -u developer $FLUTTER_CONTAINER ${ANDROID_SDK_ROOT:-/opt/android-sdk}/platform-tools/adb devices | awk 'NR>1 && NF{print $1}' || true)
    COUNT=$(echo "$DEVICES" | wc -w)

    if [ "$COUNT" -eq 0 ]; then
      echo "No devices are visible to the flutter container."
      exit 0
    elif [ "$COUNT" -eq 1 ]; then
      DEVICE_ID=$(echo "$DEVICES" | tr -d '\n')
      echo "One device detected: $DEVICE_ID"
      echo "You can run: $0 flutter run -d $DEVICE_ID"
    else
      echo "Multiple devices detected. Choose one by running:"
      echo "  $0 flutter devices"
      echo "Then run: $0 flutter run -d <device-id>"
    fi
    ;;

  flutter)
    if [ $# -eq 0 ]; then
      echo "Usage: $0 flutter <flutter-args...>"
      exit 1
    fi
    docker compose exec -u developer flutter bash -lc "$*"
    ;;

  shell)
    docker compose exec flutter bash
    ;;

  help|-h|--help)
    usage
    ;;

  *)
    echo "Unknown command: $cmd" >&2
    usage
    exit 2
    ;;
esac
