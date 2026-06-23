SHELL := /bin/bash

# ============================================================
# Choose workflow:
#   make -f Makefile.local  <target>   — local Flutter (no Docker)
#   make -f Makefile.docker <target>   — Docker / container
# ============================================================

.PHONY: help

help:
	@echo "Two workflows available:"
	@echo ""
	@echo "  Local (no Docker):"
	@echo "    make -f Makefile.local help"
	@echo ""
	@echo "  Docker:"
	@echo "    make -f Makefile.docker help"
