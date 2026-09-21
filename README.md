# clean_architecture_getx

A Flutter project with Clean Architecture and automated feature generation.

---

## ⚙️ Environment Setup

Config (`API_BASE_URL`, `API_VERSION`, `APP_DEBUG`, `DEFAULT_LOCALE`, `DEVICE_SECRET`)
is injected at build time via `--dart-define-from-file`, not `.env`/`flutter_dotenv`.
Values live in `.env/*.json`, read in `lib/app/flavours/app_config.dart`.

```text
.env/
├── example.json   # committed template, blank values
├── dev.json       # gitignored — copy from example.json and fill in
├── staging.json   # gitignored
└── prod.json      # gitignored
```

1. Copy the template: `cp .env/example.json .env/dev.json` (and
   `staging.json`/`prod.json` if you need those builds).
2. Fill in the real values — get them from a teammate or your secrets
   manager, never commit them.
3. Run with the flag directly: `flutter run --dart-define-from-file=.env/dev.json`

```bash
flutter run --dart-define-from-file=.env/dev.json
flutter build apk --release --dart-define-from-file=.env/prod.json
```

**VS Code**: no `.vscode/launch.json` committed yet. Add one with a
"Run (dev)" config using `toolArgs: ["--dart-define-from-file", ".env/dev.json"]`
(duplicate for staging/prod) to pick a flavor from the Run and Debug panel.

**Android Studio**: `.idea/` isn't committed, so each machine needs this once:
**Run → Edit Configurations → main.dart** (create it if missing, pointing at
`lib/main.dart`) → **Additional run args** → set to
`--dart-define-from-file=.env/dev.json` (swap the filename for staging/prod
configs).

This covers public/build-time config only. Runtime user/session secrets (auth
tokens, etc.) go through `flutter_secure_storage`, never this mechanism. True
server-side secrets (API keys, signing secrets) never enter the app at all —
they stay on the backend.

---

## Feature generator

Run from the project root with the pinned SDK:

```bash
fvm flutter pub get
fvm dart run generate_feature.dart user_profile --dry-run
fvm dart run generate_feature.dart user_profile
```

The generator reads the package name from `pubspec.yaml`, creates ten formatted
Dart files, and refuses to overwrite an existing feature unless you pass
`--force`. `--force` replaces the ten generated files, including customizations;
it preserves other files. Use `--help` for usage. Names must be lowercase
snake_case (for example `user_profile`), with no empty segments or reserved words.

Generated structure:

```text
lib/features/user_profile/
├── data/
│   ├── model/user_profile_list_response.dart
│   └── repo_impl/
│       ├── user_profile_http_impl.dart
│       └── user_profile_cache_impl.dart
├── domain/
│   ├── entity/user_profile_item.dart
│   ├── repo/user_profile_repository.dart
│   └── usecase/user_profile_use_case.dart
└── presentation/
    ├── bindings/user_profile_binding.dart
    ├── controller/user_profile_screen_controller.dart
    ├── screens/user_profile_screen.dart
    └── pages.dart
```

Complete the feature in these steps:

1. Add business fields to `domain/entity/user_profile_item.dart`.
2. Update the DTO's `fromJson`, `toJson`, `fromEntity`, and `toEntity` mappings in
   `data/model/user_profile_list_response.dart`. These mappings also serialize
   the cache, so keep them consistent. The default response envelope uses
   `Success`, `Data`, and `ErrorMessage`, with `id`/`name` item fields.
3. Set `_endpoint` in `data/repo_impl/user_profile_http_impl.dart` to your absolute
   API URL, or replace it with your URL provider. The default implementation uses
   `authorizedGet`, so authentication must already be initialized. Until an
   endpoint is configured, it returns a visible configuration error without
   making a request.
4. Import the generated pages into `lib/res/routes/app_pages.dart` and add
   `...UserProfilePages.routes` to `AppPages.routes`. Use your actual package name
   in the import, or use a relative import:

   ```dart
   import '../../features/user_profile/presentation/pages.dart';
   ```

5. Navigate with `Get.toNamed(UserProfilePages.routeName)`. Generated pages own
   their route constant, so they compile before registration. If you prefer
   central route constants, add an alias to `AppRoutes` yourself.
6. Customize and localize the generated screen's text, then test the API mapping
   and screen with your data.

Generated behavior:

- Initial load uses a valid cached response when available (one-day TTL).
- Pull-to-refresh and Retry pass `forceRefresh: true` through the use case and
  repository to bypass the cache and save fresh data.
- Invalid or unavailable cached data falls back to the remote repository. A cache
  write failure does not discard a successful response. A failed refresh keeps
  the previous cached value and visible list.
- The screen supports loading, empty, error/retry, data, and refresh states.
  Short and empty lists remain scrollable for pull-to-refresh.
- Unexpected controller failures reset loading and show an inline error.
- DTOs own serialization; domain entities remain pure Dart. Bindings connect
  HTTP → cache repository → use case → controller.

The generated cache key is feature-scoped and versioned. For user-specific data,
include the account ID in the cache key or clear that feature's data on logout.
Bump the cache-key version when changing an incompatible cached schema.

Run generator regression tests:

```bash
fvm flutter test test/tool/feature_generator_test.dart
```

The suite checks CLI validation, overwrite protection, symbolic-link protection,
package renaming, formatting, generated-code analysis, cache policies, and
controller/widget behavior in a temporary project. Existing generated features
are not migrated automatically.

---

## 🐳 Docker Development (Run everything in containers)

You can run and test the app entirely inside Docker. This is the recommended way to ensure everyone on the team has the same SDKs, toolchains and emulator behaviour.

Quick start (emulator-in-container)

1. Build images and start services (emulator + flutter):

   ./scripts/start.sh

2. (If needed) force adb connect:

   ./scripts/start.sh connect

Troubleshooting: "No physical devices found" and connection errors

- If you see a message like "No physical devices found. Attempting to connect to emulator at :5555" or "no host in ':5555'", it means the start script could not determine the emulator container IP. Try:

  - Run: ./scripts/start.sh connect
  - If that still shows no devices, exec into the flutter container and try connecting to the emulator service name (Docker internal DNS):

    docker compose exec -u developer -T flutter bash -lc "/opt/android-sdk/platform-tools/adb connect emulator:5555 && /opt/android-sdk/platform-tools/adb devices -l"

  - Or get the emulator container IP and connect directly (replace <ip>):

    EMU_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker compose ps -q emulator))
    docker compose exec -u developer -T flutter bash -lc "/opt/android-sdk/platform-tools/adb connect ${EMU_IP}:5555 && /opt/android-sdk/platform-tools/adb devices -l"

  - If you plan to access adb from your local machine, create an SSH tunnel from your laptop to the server to forward port 5555 (recommended) instead of opening ports in the server firewall.

3. Exec into flutter container and run the app:

   ./scripts/start.sh shell
   # inside container
   flutter pub get
   flutter devices
   flutter run -d <device-id>

Alternatively use the convenience script to connect adb from the flutter container to the emulator container:

    ./scripts/start.sh connect

Or to connect host adb to the emulator (requires adb on host):

    ./scripts/start.sh connect host

Run a single flutter command from the host (convenience via Makefile):

  make flutter run -d <device-id>

Makefile targets (shortcuts):

- make up         # build + start (same as ./scripts/start.sh up)
- make connect    # connect flutter adb to emulator
- make shell      # open shell into flutter container
- make flutter ...# run flutter <args> inside the container
- make down       # stop and remove containers
- make logs       # follow emulator logs
Additional Makefile helpers:

- make ensure-perms     # ensure repo helper scripts are executable
- make recreate-volumes # remove compose volumes and restart emulator (repopulates SDK bundle)
- make reset-volumes    # alias for recreate-volumes
- make devcontainer     # start VS Code devcontainer via devcontainer CLI (if .devcontainer exists)

- make emulator-container   # start the emulator via the repo scripts in container mode (EMULATOR_MODE=container)
- make emulator-host-connect # connect the flutter container to a host-running emulator (EMULATOR_MODE=host)

Emulator Modes

- container: runs the emulator fully inside Docker. Reliable on Linux with KVM (x86_64), and supported on Apple Silicon (ARM64). On macOS Intel/Windows, uses x86_64 emulation (slower but works).
- host: run the Android emulator on your host (Android Studio or sdk/emulator) and connect the Flutter container to it via adb (adb connect localhost:5555).
- auto (default): the start script detects the host OS/arch and chooses container mode where supported, else host mode.

You can override with EMULATOR_MODE=container|host|auto when running scripts/start.sh or `make up`.

## macOS Apple Silicon (M1/M2/M3) Setup

The setup automatically detects Apple Silicon (ARM64) and uses the ARM64 Android emulator in container mode.

1. Ensure ARM64 emulator binaries are available (copy `linux/emulator/` from cryze repo or build them) into `docker/emulator/` directory.

2. Run in container mode (detected automatically):

   ```bash
   make up
   ```

3. Connect and run Flutter:

   ```bash
   make connect
   make flutter devices
   make flutter run -d emulator-5554
   ```

**Multi-OS Support:** The setup automatically detects the host architecture:
- **ARM64 (Apple Silicon):** Uses ARM64 emulator in container mode
- **x86_64 (Intel Macs, Linux, Windows):** Uses x86_64 emulator in container mode (requires KVM on Linux for best performance) or falls back to host mode

For graphical interaction, use scrcpy with the VNC port (5900) or connect to the emulator via ADB.

Use a physical Android device (Linux USB passthrough)

1. Start with the usb override (Linux only):

   docker compose -f docker-compose.yml -f docker-compose.override.usb.yml up --build -d

2. Then run the normal start and connect commands (start.sh will still help):

    ./scripts/start.sh
    ./scripts/start.sh connect

Host emulator (macOS/Windows)

- Start the emulator on your host (Android Studio or command line) and then connect the flutter container to the host adb:

  docker compose exec flutter bash -lc "/opt/android-sdk/platform-tools/adb connect host.docker.internal:5555"

Stopping everything

  docker compose down

Alternative: use a prebuilt android-build-box image for one-off commands

If you prefer not to build the images in this repo you can use the community image `mingc/android-build-box` to run one-off commands against the project folder (example below runs tests):

  docker run --rm -v "$(pwd)":/project -w /project -e ANDROID_SDK_ROOT=/opt/android-sdk mingc/android-build-box:latest bash -lc "flutter pub get && flutter test"

New: docker-compose (no custom Dockerfiles)

1. Start stack (emulator + flutter + scrcpy-web):

   make up

2. Open a shell inside the flutter container:

   make shell

3. Run flutter commands from host via Makefile:

   make flutter devices
   make flutter run -d emulator

4. Open scrcpy-web (VNC-like web UI) in your browser at:

   http://localhost:8080

Notes:

- The compose stack uses the public image mingc/android-build-box for both the emulator (android) and the flutter dev container (flutter). No custom image is built.
- scrcpy-web connects to the adb server exported by the android service. If scrcpy-web doesn't show the device, exec into the scrcpy-web container and ensure it can reach adb at android:5037.
- To stop everything: `make down`.

Port collisions and multi-arch images

- If port 8080 is already used on the host, the compose `up` will fail. You can change the host port for scrcpy-web with an environment variable when running compose, for example:

  SCRCPY_WEB_PORT=8081 make up

- The scrcpy-web image used must match your host architecture. The compose file uses a multi-arch-friendly image by default; if you still see platform mismatch messages, select a scrcpy-web image that matches your host (search Docker Hub for `scrcpy-web` and pick an image with the appropriate platform support).

VS Code devcontainer

- Open the repository in VS Code and use the Remote - Containers (Dev Containers) extension to reopen in container. The .devcontainer/devcontainer.json targets the `flutter` service.

More commands and troubleshooting are available in docker/README.md — it contains detailed platform-specific instructions and examples.


## 📚 Additional Resources

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [GetX Documentation](https://pub.dev/packages/get)
- [Dartz for Functional Programming](https://pub.dev/packages/dartz)

---

## 🤝 Contributing

1. Generate your feature using the CLI tool
2. Follow the established patterns
3. Test thoroughly
4. Submit your PR

---

**Generate → Update → Register → Test** 🚀

Made with ❤️ for fast Flutter development
