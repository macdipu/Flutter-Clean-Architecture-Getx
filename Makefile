SHELL := /bin/bash
SCRIPTDIR := ./scripts

.PHONY: up connect shell flutter build down logs emulator emulator-container emulator-host-connect

up:
	@echo "Ensuring scripts are executable"
	@$(SHELL) -c 'chmod +x scripts/*.sh docker/emulator/*.sh || true'
	@echo "Starting development environment (build + up)"
	@$(SCRIPTDIR)/start.sh up

connect:
	@echo "Connect flutter container adb to emulator"
	@$(SCRIPTDIR)/start.sh connect

shell:
	@echo "Open shell into flutter container"
	@$(SCRIPTDIR)/start.sh shell

flutter:
	@echo "Run flutter command inside flutter container"
	@$(SCRIPTDIR)/start.sh flutter $(filter-out $@,$(MAKECMDGOALS))

build:
	@echo "Build images"
	docker compose build

down:
	@echo "Stop and remove containers"
	docker compose down

logs:
	@echo "Follow emulator logs"
	docker compose logs -f dockerify-android

emulator:
	@echo "Start only the emulator service"
	docker compose up -d dockerify-android

.PHONY: emulator-container emulator-host-connect

emulator-container:
	@echo "Start emulator service (container mode)"
	@SCRIPTDIR=$(SCRIPTDIR) EMULATOR_MODE=container $(SHELL) -c '$(SCRIPTDIR)/start.sh up'

emulator-host-connect:
	@echo "Ensure host emulator is running and connect flutter container to host adb"
	@SCRIPTDIR=$(SCRIPTDIR) EMULATOR_MODE=host $(SHELL) -c '$(SCRIPTDIR)/start.sh connect'

.PHONY: ensure-perms recreate-volumes devcontainer reset-volumes

ensure-perms:
	@echo "Making scripts executable"
	@$(SHELL) -c 'chmod +x scripts/*.sh docker/emulator/*.sh || true'

# Reset volumes by bringing the compose stack down with volumes removed,
# then start the emulator so the SDK bundle is copied into the fresh volume.
recreate-volumes: down
	@echo "Removing volumes and restarting emulator to repopulate SDK bundle"
	@docker compose down -v || true
	@docker compose up -d dockerify-android
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
