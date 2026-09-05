#!/usr/bin/env bash
# Captures Play Store phone screenshots (Today / Calendar / Insights tabs)
# from a running Habitly instance on a connected Android device/emulator.
#
# Requires the app already installed and launchable (e.g. after
# `flutter run -d <device>` or installing a built APK). Taps the bottom nav
# bar by even quarter-width columns, so it's resolution-independent as long
# as the standard 4-tab bottom nav is on screen.
#
# Usage: bash tool/capture_store_screenshots.sh [device-serial]
# Writes: docs/store/screenshots/01_today.png, 02_calendar.png, 03_insights.png
set -euo pipefail
cd "$(dirname "$0")/.."
export MSYS_NO_PATHCONV=1

DEVICE="${1:-emulator-5554}"
PACKAGE="io.github.macdipu.habitly"
OUT_DIR="docs/store/screenshots"
REMOTE="/sdcard/habitly_shot.png"

adb -s "$DEVICE" shell am start -n "$PACKAGE/.MainActivity" >/dev/null
sleep 6

read -r WIDTH HEIGHT <<<"$(adb -s "$DEVICE" shell wm size | sed -n 's/.*: \([0-9]*\)x\([0-9]*\)/\1 \2/p')"
if [ -z "${WIDTH:-}" ] || [ -z "${HEIGHT:-}" ]; then
  echo "Could not read device screen size" >&2
  exit 1
fi

# Bottom nav: 4 equal-width tabs (Today, Calendar, Insights, Settings),
# tap centers at the odd eighths of the width; y near the bottom, above the
# gesture bar (0.927 of height matches the standard 3-button/gesture nav
# height on this project's test emulator - adjust if yours differs).
tab_x() { echo $(( WIDTH * (2 * $1 + 1) / 8 )); }
TAB_Y=$(( HEIGHT * 927 / 1000 ))

capture() {
  local name="$1"
  adb -s "$DEVICE" shell screencap -p "$REMOTE"
  mkdir -p "$OUT_DIR"
  adb -s "$DEVICE" pull "$REMOTE" "$OUT_DIR/$name" >/dev/null
  echo "Wrote $OUT_DIR/$name"
}

adb -s "$DEVICE" shell input tap "$(tab_x 0)" "$TAB_Y"   # Today
sleep 1
capture "01_today.png"

adb -s "$DEVICE" shell input tap "$(tab_x 1)" "$TAB_Y"   # Calendar
sleep 1
capture "02_calendar.png"

adb -s "$DEVICE" shell input tap "$(tab_x 2)" "$TAB_Y"   # Insights
sleep 1
capture "03_insights.png"

adb -s "$DEVICE" shell rm -f "$REMOTE"
