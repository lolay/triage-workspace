# Contributing to triage-workspace

This file covers the workspace wrapper itself. For contributing to a child
repo (`triage`, `triage-action`, etc.), see that repo's own `CONTRIBUTING.md`.

## What belongs here vs. in a child repo

**This workspace tracks only:**
- `Makefile` / `Makefile.md` / `repos.mk` — cross-repo orchestration
- `README.md` / `AGENTS.md` / `CONTRIBUTING.md` / `CHANGELOG.md` / `LICENSE`
- `triage.code-workspace` — multi-root workspace file

**Never commit here:**
- Child repo source code — each repo is gitignored and tracks its own history
- CI workflows — the workspace never runs automation
- Per-repo build scripts, specs, or ops runbooks — those belong in their own repo

## Setup

```bash
git clone git@github.com:lolay/triage-workspace.git
cd triage-workspace
make init      # clone missing repos + per-repo make init + doctor
```

`make init` is idempotent: re-running it on a machine where all repos are
already present clones nothing.

## Updating the manifest

When a repo is added to or removed from the estate, update [`repos.mk`](./repos.mk):

1. Add/remove the repo name from `REPOS` (uncomment the prepared placeholder).
2. Add/remove its `REPO_URL.*` and `REPO_BRANCH.*` entries.
3. Add/remove it from whichever flag lists apply
   (`REPOS_MAKE_INIT`, `REPOS_BUILD_ORDER`, `REPOS_MAKE_CI`, `REPOS_MAKE_CLEAN`).
4. Update the estate table in [`README.md`](./README.md) to reflect the change.
5. Add a `CHANGELOG.md` entry under `## [Unreleased]`.
6. Add the new repo path to [`triage.code-workspace`](./triage.code-workspace).

## Worktree convention

Worktrees for child repos land as **siblings** of the main checkout inside
this workspace root — i.e. at the same level as `triage/`, `triage-action/`,
etc. The allowlist `.gitignore` (`/*` then selective un-ignores) covers them
automatically; no `.gitignore` changes are needed as branches come and go.

**Naming:** `<repo>-<branch-slug>` where the branch slug is the branch name
with any type prefix stripped (`feature/`, `feat/`, `fix/`, `bugfix/`,
`release/`, `hotfix/`, `chore/`). Slashes become hyphens.

```bash
# Create a worktree for branch feat/foo in triage:
git -C triage worktree add ../triage-foo -b feat/foo
# triage-foo/ lands at the workspace root — already gitignored

# Remove when done:
git -C triage worktree remove ../triage-foo
git -C triage branch -d feat/foo
```

## Commits and pull requests

- Commits: imperative mood, ≤72 chars, no trailing period. No emojis.
- PRs: one logical change each, squash-merged.
- Add a `CHANGELOG.md` entry for any user-observable change to the workspace
  itself (new target, manifest change, doc update).
