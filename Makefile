SHELL := /bin/bash
SCRIPTDIR := ./scripts

.PHONY: up connect shell flutter build down logs emulator emulator-container emulator-host-connect compose-up compose-shell compose-flutter compose-logs

up:
	@echo "Starting development environment with docker compose"
	@docker compose up -d --build

connect:
	@echo "Connect flutter container adb to emulator (uses adb over network)."
	@echo "Run 'make shell' then inside container: adb connect android:5555" || true

shell:
	@echo "Open shell into flutter container"
	@docker compose exec flutter /bin/bash

flutter:
	@echo "Run flutter command inside flutter container"
	@docker compose exec flutter bash -lc "flutter $(filter-out $@,$(MAKECMDGOALS))"

build:
	@echo "Build images"
	docker compose build

# Build Flutter artifacts inside the flutter service and save logs/artifacts to the workspace
.PHONY: build-apk build-debug-apk build-aab build-logs

build-apk:
	@echo "Building release APK and saving artifacts/logs"
	@docker compose exec flutter bash -lc "mkdir -p /workspace/build_artifacts /workspace/build_logs && flutter pub get && flutter build apk --release 2>&1 | tee /workspace/build_logs/build-apk-release.log; cp build/app/outputs/flutter-apk/app-release.apk /workspace/build_artifacts/ || echo 'app-release.apk not found'"

build-debug-apk:
	@echo "Building debug APK and saving artifacts/logs"
	@docker compose exec flutter bash -lc "mkdir -p /workspace/build_artifacts /workspace/build_logs && flutter pub get && flutter build apk --debug 2>&1 | tee /workspace/build_logs/build-apk-debug.log; cp build/app/outputs/flutter-apk/app-debug.apk /workspace/build_artifacts/ || echo 'app-debug.apk not found'"

build-aab:
	@echo "Building Android App Bundle (AAB) and saving artifacts/logs"
	@docker compose exec flutter bash -lc "mkdir -p /workspace/build_artifacts /workspace/build_logs && flutter pub get && flutter build appbundle --release 2>&1 | tee /workspace/build_logs/build-aab-release.log; cp build/app/outputs/bundle/release/app-release.aab /workspace/build_artifacts/ || echo 'app-release.aab not found'"

build-logs:
	@echo "List saved build logs and artifacts"
	@ls -la build_logs build_artifacts || true
	@echo "To view a log: tail -f build_logs/<log-file>"

.PHONY: run run-debug

run: emulator
	@echo "Waiting for emulator/device to become available and running 'flutter run' (debug)"
	@docker compose exec flutter bash -lc "set -e; \
	for i in \$(seq 1 60); do \n+	  echo \"[run] waiting for adb (attempt $${i}/60)\"; \n+	  adb connect android:5555 >/dev/null 2>&1 || true; \n+	  if adb devices | awk 'NR>1 && \$2==\"device\" {print \$1; exit}' >/dev/null 2>&1; then \n+	    echo '[run] device found'; break; \n+	  fi; \n+	  sleep 1; \n+	done; \n+	flutter pub get; \n+	flutter run"

run-debug: run


down:
	@echo "Stop and remove containers"
	docker compose down

logs:
	@echo "Follow compose logs for android and scrcpy-web"
	docker compose logs -f android scrcpy-web

emulator:
	@echo "Start only the android emulator service"
	docker compose up -d android

.PHONY: emulator-container emulator-host-connect ensure-perms recreate-volumes devcontainer reset-volumes

emulator-container:
	@echo "Start emulator service (container mode)"
	@SCRIPTDIR=$(SCRIPTDIR) EMULATOR_MODE=container $(SHELL) -c '$(SCRIPTDIR)/start.sh up' || true

emulator-host-connect:
	@echo "Ensure host emulator is running and connect flutter container to host adb"
	@SCRIPTDIR=$(SCRIPTDIR) EMULATOR_MODE=host $(SHELL) -c '$(SCRIPTDIR)/start.sh connect' || true

ensure-perms:
	@echo "Making scripts executable"
	@$(SHELL) -c 'chmod +x scripts/*.sh docker/emulator/*.sh || true'

# Reset volumes by bringing the compose stack down with volumes removed,
# then start the emulator so the SDK bundle is copied into the fresh volume.
recreate-volumes: down
	@echo "Removing volumes and restarting emulator to repopulate SDK bundle"
	@docker compose down -v || true
	@docker compose up -d android
	@echo "Emulator started; SDK bundle will be copied into the named volume on first run."

# alias for recreate-volumes
reset-volumes: recreate-volumes

# Start devcontainer using the devcontainer CLI when available.
devcontainer:
	@if [ -f .devcontainer/devcontainer.json ]; then \
	  if command -v devcontainer >/dev/null 2>&1; then \
	    echo "Starting devcontainer (devcontainer up)..."; \
	    devcontainer up --workspace-folder .; \
	  else \
	    echo "devcontainer CLI not found. Install with: npm i -g @devcontainers/cli"; \
	    echo "Or open in VS Code: Remote - Containers / Reopen in Container"; \
	    exit 1; \
	  fi \
	else \
	  echo "No .devcontainer directory found in repository."; \
	  exit 1; \
	fi

# Support passing arguments to 'make flutter' like: make flutter run -d emulator
%:
	@:
