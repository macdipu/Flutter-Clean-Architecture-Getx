# Emulator Container (ws-scrcpy)

This container runs a headless Android emulator and exposes a websocket-based scrcpy server.

## Quick Start

- Build and start the emulator service:

```bash
docker-compose up --build emulator
```

- The first run will download a system image if `ANDROID_SYSTEM_IMAGE` is set in `docker-compose.yml`.

Note: The container uses supervisord to run a first-boot setup that may take 5–15 minutes on first start as it downloads system images and creates the AVD. Monitor progress with `docker compose logs -f emulator`.

## Ports

- `5555`: ADB over TCP
- `8082 -> 8080`: ws-scrcpy / web UI (host:container)

## Environment Variables

- `ANDROID_EMULATOR_NAME`: AVD name to launch (default: `android_emulator` in `docker-compose.yml`)
- `ANDROID_SYSTEM_IMAGE`: System image to install if the AVD is missing
  - Example: `system-images;android-33;google_apis;x86_64`
- `ANDROID_DEVICE`: Device profile for AVD creation (default: `pixel`)

## Notes

- On macOS, running an Android emulator inside Docker may not have hardware acceleration. A Linux host with KVM is recommended for best performance.
- If you already created AVDs, mount them into `/home/developer/.android/avd` via the `emulator_home` volume.
