SHELL := /bin/bash
SCRIPTDIR := ./scripts

# ============================================================
# Main Development Commands
# ============================================================

.PHONY: help

help:
	@echo "Available commands:"
	@echo ""
	@echo "Environment:"
	@echo "  make up        - Start all services (docker compose)"
	@echo "  make down       - Stop and remove all containers"
	@echo "  make logs       - View running container logs"
	@echo "  make build      - Build docker images"
	@echo ""
	@echo "Container:"
	@echo "  make shell      - Open shell into flutter container"
	@echo "  make run        - Run app on emulator (debug)"
	@echo ""
	@echo "Build:"
	@echo "  make apk        - Build release APK"
	@echo "  make debug      - Build debug APK"
	@echo "  make aab        - Build Android App Bundle"
	@echo "  make artifacts  - List build artifacts/logs"
	@echo ""
	@echo "Emulator:"
	@echo "  make emulator   - Start Android emulator"
	@echo "  make connect    - Connect to host emulator"
	@echo ""
	@echo "Utils:"
	@echo "  make perms      - Make scripts executable"
	@echo "  make reset      - Reset docker volumes"
	@echo "  make devcontainer - Start devcontainer"

# ============================================================
# Environment
# ============================================================

.PHONY: up down logs build

up:
	@echo "Starting development environment..."
	@docker compose up -d --build

down:
	@echo "Stopping development environment..."
	@docker compose down

logs:
	@echo "Following logs for android and scrcpy-web..."
	@docker compose logs -f android scrcpy-web

build:
	@echo "Building docker images..."
	@docker compose build

# ============================================================
# Container
# ============================================================

.PHONY: shell run

shell:
	@echo "Opening shell into flutter container..."
	@docker compose exec flutter /bin/bash

run:
	@echo "Waiting for emulator and running flutter app..."
	@docker compose exec flutter bash -lc "set -e; \
	for i in \$(seq 1 60); do \
	  echo \"[run] waiting for adb (attempt $${i}/60)\"; \
	  adb connect android:5555 >/dev/null 2>&1 || true; \
	  if adb devices | awk 'NR>1 && \$2==\"device\" {print \$1; exit}' >/dev/null 2>&1; then \
	    echo '[run] device found'; break; \
	  fi; \
	  sleep 1; \
	done; \
	flutter pub get; \
	flutter run"

# ============================================================
# Build
# ============================================================

.PHONY: apk debug aab artifacts

apk:
	@echo "Building release APK..."
	@docker compose exec flutter bash -lc "mkdir -p /workspace/build_artifacts /workspace/build_logs && flutter pub get && flutter build apk --release 2>&1 | tee /workspace/build_logs/build-apk-release.log; cp build/app/outputs/flutter-apk/app-release.apk /workspace/build_artifacts/ || echo 'app-release.apk not found'"

debug:
	@echo "Building debug APK..."
	@docker compose exec flutter bash -lc "mkdir -p /workspace/build_artifacts /workspace/build_logs && flutter pub get && flutter build apk --debug 2>&1 | tee /workspace/build_logs/build-apk-debug.log; cp build/app/outputs/flutter-apk/app-debug.apk /workspace/build_artifacts/ || echo 'app-debug.apk not found'"

aab:
	@echo "Building Android App Bundle (AAB)..."
	@docker compose exec flutter bash -lc "mkdir -p /workspace/build_artifacts /workspace/build_logs && flutter pub get && flutter build appbundle --release 2>&1 | tee /workspace/build_logs/build-aab-release.log; cp build/app/outputs/bundle/release/app-release.aab /workspace/build_artifacts/ || echo 'app-release.aab not found'"

artifacts:
	@echo "Build artifacts:"
	@ls -la build_artifacts 2>/dev/null || echo "No artifacts found"
	@echo "Build logs:"
	@ls -la build_logs 2>/dev/null || echo "No logs found"
	@echo "To view a log: tail -f build_logs/<log-file>"

# ============================================================
# Emulator
# ============================================================

.PHONY: emulator connect

emulator:
	@echo "Starting Android emulator..."
	@docker compose up -d android

connect:
	@echo "Connecting flutter container adb to host emulator..."
	@echo "Ensure emulator is running on host, then connect via: adb connect android:5555"
	@docker compose exec flutter adb connect android:5555 || true

# ============================================================
# Utils
# ============================================================

.PHONY: perms reset devcontainer

perms:
	@echo "Making scripts executable..."
	@$(SHELL) -c 'chmod +x scripts/*.sh docker/emulator/*.sh || true'

reset:
	@echo "Resetting volumes and restarting emulator..."
	@docker compose down -v || true
	@docker compose up -d android

devcontainer:
	@if [ -f .devcontainer/devcontainer.json ]; then \
	  if command -v devcontainer >/dev/null 2>&1; then \
	    echo "Starting devcontainer..."; \
	    devcontainer up --workspace-folder .; \
	  else \
	    echo "devcontainer CLI not found. Install with: npm i -g @devcontainers/cli"; \
	    exit 1; \
	  fi \
	else \
	  echo "No .devcontainer directory found."; \
	  exit 1; \
	fi

# Fallback for any other command - pass to flutter container
%:
	@docker compose exec flutter bash -lc "flutter $@" 2>/dev/null || true