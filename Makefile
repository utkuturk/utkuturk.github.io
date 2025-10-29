# =========================
# Quarto → gh-pages Makefile
# =========================
# Usage:
#   make render             # local 'quarto render'
#   make publish            # render + push built site to gh-pages
#   make bootstrap-pages    # one-time: create gh-pages branch (if missing)
#   make clean              # clean build artifacts
#
# Optional: override CNAME on the command line, e.g.:
#   make publish CNAME=utkuturk.com
#   make publish CNAME=     # (disable CNAME file for this run)
#
# Notes:
# - By default Quarto outputs to "_site". If your _quarto.yml sets a
#   different 'output-dir', override SITE_DIR=that_dir when calling make.

SHELL := /bin/bash

# ---- Config (override via CLI if needed) ----
REPO_ROOT      := $(shell git rev-parse --show-toplevel)
SITE_DIR       ?= _site
PUBLISH_BRANCH ?= gh-pages
PUBLISH_DIR    ?= $(REPO_ROOT)/.gh-pages-worktree
CURRENT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
COMMIT_SHA     := $(shell git rev-parse --short HEAD)
UTC_NOW        := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
CNAME          ?= www.utkuturk.com   # <— default CNAME

# Detect if gh-pages exists on remote
REMOTE_HAS_PAGES := $(shell git ls-remote --exit-code --heads origin $(PUBLISH_BRANCH) >/dev/null 2>&1 && echo yes || echo no)

.PHONY: help render clean bootstrap-pages publish _ensure_worktree _teardown_worktree

help:
	@echo "Targets:"
	@echo "  make render            - Render the Quarto site locally"
	@echo "  make publish           - Render locally and publish to '$(PUBLISH_BRANCH)'"
	@echo "  make bootstrap-pages   - One-time bootstrap for '$(PUBLISH_BRANCH)' branch"
	@echo "  make clean             - Clean build artifacts"

# ----- Build -----
render:
	@echo "==> Rendering site locally with Quarto…"
	@quarto render
	@echo "==> Done. Built at: $(SITE_DIR)"

clean:
	@echo "==> Cleaning Quarto outputs…"
	@quarto clean || true
	@rm -rf "$(SITE_DIR)"
	@echo "==> Clean complete."

# ----- One-time bootstrap of gh-pages branch (if missing) -----
bootstrap-pages:
	@echo "==> Bootstrapping branch '$(PUBLISH_BRANCH)'…"
	@rm -rf "$(PUBLISH_DIR)" 2>/dev/null || true
	@if [ "$(REMOTE_HAS_PAGES)" = "yes" ]; then \
	  echo "   Remote branch '$(PUBLISH_BRANCH)' already exists."; \
	  git worktree add "$(PUBLISH_DIR)" "$(PUBLISH_BRANCH)"; \
	else \
	  echo "   Creating '$(PUBLISH_BRANCH)' as an orphan branch…"; \
	  git worktree add "$(PUBLISH_DIR)" -b "$(PUBLISH_BRANCH)"; \
	fi
	@cd "$(PUBLISH_DIR)" && \
	  rm -rf ./* && \
	  touch .nojekyll && \
	  if [ -n "$(CNAME)" ]; then echo "$(CNAME)" > CNAME; fi && \
	  git add -A && \
	  git commit -m "Bootstrap $(PUBLISH_BRANCH) [$(UTC_NOW)]" || true && \
	  git push -u origin "$(PUBLISH_BRANCH)" || true
	@$(MAKE) _teardown_worktree
	@echo "==> Bootstrap complete."

# ----- Publish (render locally, then push built files to gh-pages) -----
publish: render
	@echo "==> Publishing '$(SITE_DIR)' to branch '$(PUBLISH_BRANCH)'…"
	@rm -rf "$(PUBLISH_DIR)" 2>/dev/null || true
	@if [ "$(REMOTE_HAS_PAGES)" = "yes" ]; then \
	  git worktree add "$(PUBLISH_DIR)" "$(PUBLISH_BRANCH)"; \
	else \
	  echo "   Remote '$(PUBLISH_BRANCH)' is missing; creating it…"; \
	  git worktree add "$(PUBLISH_DIR)" -b "$(PUBLISH_BRANCH)"; \
	fi

	# Sync built files into the worktree
	@if [ ! -d "$(SITE_DIR)" ]; then \
	  echo "ERROR: Built site directory '$(SITE_DIR)' not found. Did 'quarto render' run?"; \
	  $(MAKE) _teardown_worktree; \
	  exit 1; \
	fi

	# Prefer rsync if available (fast + --delete). Fallback: rm && cp -a.
	@if command -v rsync >/dev/null 2>&1; then \
	  rsync -a --delete "$(SITE_DIR)/" "$(PUBLISH_DIR)/"; \
	else \
	  echo "rsync not found; using rm/cp fallback…"; \
	  rm -rf "$(PUBLISH_DIR)"/*; \
	  cp -a "$(SITE_DIR)/." "$(PUBLISH_DIR)/"; \
	fi

	# Add .nojekyll and optional CNAME each publish (idempotent)
	@touch "$(PUBLISH_DIR)/.nojekyll"
	@if [ -n "$(CNAME)" ]; then echo "$(CNAME)" > "$(PUBLISH_DIR)/CNAME"; fi

	# Commit and push if there are changes
	@cd "$(PUBLISH_DIR)" && \
	  git add -A && \
	  if git diff --cached --quiet; then \
	    echo "==> No changes to publish."; \
	  else \
	    git commit -m "Publish from $(CURRENT_BRANCH) @ $(COMMIT_SHA) [$(UTC_NOW)]" && \
	    git push origin "$(PUBLISH_BRANCH)"; \
	    echo "==> Published to '$(PUBLISH_BRANCH)'."; \
	  fi

	@$(MAKE) _teardown_worktree
	@echo "==> Done."

# ----- Internal helpers -----
_teardown_worktree:
	@echo "==> Cleaning temporary worktree…"
	@git worktree remove -f "$(PUBLISH_DIR)" 2>/dev/null || true
	@rm -rf "$(PUBLISH_DIR)" 2>/dev/null || true