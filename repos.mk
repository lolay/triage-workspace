# =============================================================================
# repos.mk — triage-workspace repository manifest
#
# Source of truth for the estate: every repository that belongs to this
# workspace, its GitHub remote, default branch, and participation flags.
#
# Include in the root Makefile with `include repos.mk`.
#
# Variable name convention: REPO_URL.<dirname> / REPO_BRANCH.<dirname>
# GNU Make permits dots and hyphens in variable names.
# =============================================================================

# All repos in the workspace (directory names, as cloned/checked out).
# To add a repo: uncomment its entry below, add it to the flag lists, and run
# `make init` to clone it.
REPOS := triage triage-action
# REPOS := triage triage-action triage-secrets  # uncomment when adding triage-secrets

# Remote origin URLs
REPO_URL.triage        := git@github.com:lolay/triage.git
REPO_URL.triage-action := git@github.com:lolay/triage-action.git
# REPO_URL.triage-secrets := git@github.com:lolay/triage-secrets.git

# Default branches
REPO_BRANCH.triage        := main
REPO_BRANCH.triage-action := main
# REPO_BRANCH.triage-secrets := main

# Repos that participate in `make init` (their own `make init` is invoked)
REPOS_MAKE_INIT := triage triage-action

# Repos that participate in `make build` (in dependency order)
# triage builds the CLI binary; triage-action has no build step (lint/test only)
REPOS_BUILD_ORDER := triage

# Repos that participate in `make ci` / `make pre-commit` pass-through
REPOS_MAKE_CI := triage triage-action

# Repos that have a `make clean` target
REPOS_MAKE_CLEAN := triage triage-action

# Generated / follow-only mirrors (skipped on push, tagged in roster).
# None in this estate today.
REPOS_FOLLOW_ONLY :=

# Repos with GitHub Actions workflows (gh-runs-* delegation)
REPOS_GH := $(filter-out $(REPOS_FOLLOW_ONLY),$(REPOS))
