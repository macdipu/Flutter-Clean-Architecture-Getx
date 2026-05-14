This repository includes Docker services to run Flutter commands and an Android emulator fully inside containers.

Quick start (single-machine, no host SDK required):

1. Build images:

   docker-compose build

2. Start the emulator (detached):

   docker-compose up -d emulator

   The emulator container will populate the named volume `android_sdk` on first run from an SDK bundle baked into the image.

3. Start an interactive flutter container (source mounted) and run your app from inside the container:

   docker-compose run --service-ports --rm flutter /bin/bash

   Inside the container you can run:

   flutter pub get
   flutter devices
   flutter run -d <device_id>

Notes and tips:
- Both the emulator and flutter services share the same `android_sdk` named volume so the SDK is available in both containers.
- The emulator exposes adb ports (5555/5037); by default you do not need host adb. If you want Android Studio on your host to detect the emulator, you can connect host adb to the container with `adb connect localhost:5555` (after mapping ports and ensuring host adb is available).
- For Linux hosts with a physical device, use the docker-compose.override.usb.yml overlay to pass /dev/bus/usb into the flutter container (see the override file). On macOS/Windows Docker Desktop USB passthrough is not supported.
- The emulator runs headless (-no-window). Use flutter CLI from inside the flutter container to build and run.
