SHELL := /usr/bin/env bash

.PHONY: init setup check test ci speckit-status speckit-update github-config help

init:
	./scripts/bootstrap.sh

setup:
	./scripts/setup.sh

check:
	./scripts/check.sh

test:
	./scripts/test.sh

ci:
	./scripts/ci.sh

speckit-status:
	@command -v specify >/dev/null 2>&1 || { echo "specify is not installed; run make init"; exit 1; }
	specify integration status

speckit-update:
	@test -n "$(VERSION)" || { echo "Usage: make speckit-update VERSION=vX.Y.Z"; exit 1; }
	./scripts/update-speckit.sh "$(VERSION)"

github-config:
	./scripts/configure-github.sh

help:
	@printf '%s\n' \
	  'make init                       Initialize a repository created from this template' \
	  'make setup                      Install project dependencies' \
	  'make check                      Run static and repository checks' \
	  'make test                       Run detected project tests' \
	  'make ci                         Run all validation' \
	  'make speckit-status             Show Spec Kit integration status' \
	  'make speckit-update VERSION=... Update the pinned Spec Kit release' \
	  'make github-config              Apply recommended GitHub repository settings'
