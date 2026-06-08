# AGENTS.md

Orientation for AI coding agents (Cursor, Claude Code, OpenAI Codex CLI,
Aider) working in the **triage-workspace** wrapper. Human contributors start
with [`README.md`](./README.md) and [`CONTRIBUTING.md`](./CONTRIBUTING.md).

This file covers workspace-level rules and the delegation protocol. Rules that
apply inside a specific child repo live in that repo's own `AGENTS.md`.

## What this workspace is

A thin git repo that documents the triage estate, clones the child repos,
and provides cross-repo `make` targets (`make build`, `make ci`, `make doctor`,
etc.). It runs **no automation** and has **no CI**. Every child repo is fully
usable standalone — nothing depends on this workspace.

See the estate table in [`README.md`](./README.md) for the repo roster,
dependency map, and per-repo purpose. Read that before opening a child repo —
it answers most orientation questions without requiring you to inspect child
repos directly.

## First boot

```bash
make init      # clone missing repos + per-repo make init + doctor
make doctor    # read-only: repo roster + system tool versions
make help      # list all workspace targets
```

## Delegation protocol

**The most important rule:** when work touches files in a child repo, you must
operate as if you were launched inside that repo.

### 1. Identify the scope

Before acting on any task, identify which child repo owns the relevant code.
Use the estate table in [`README.md`](./README.md) to orient. A task may touch
multiple repos; handle them sequentially, fully completing each before moving
to the next.

### 2. Read the child repo's AGENTS.md

Before writing any code in a child repo, read and obey that repo's `AGENTS.md`
and `CONTRIBUTING.md`. These are the source of truth for:
- Build commands (always the repo's own `Makefile`)
- Code style and lint rules
- Where new files go
- Commit conventions
- CI gate (`make pre-commit` or `make ci`)

**When `triage/AGENTS.md` and this file disagree, `triage/AGENTS.md` wins**
for work done inside `triage/`. The same applies for every child repo.

### 3. Build and test using the child repo's Makefile

Never run underlying tools directly (`go build`, `golangci-lint`, etc.). Use
the child repo's Makefile:

```bash
# Work inside triage
cd triage
make init          # if not already initialised
make build         # compile
make ci            # full gate
make pre-commit    # same gate (alias)
```

Run `make help` inside the child repo for its full target list.

### 4. Update the child repo's CHANGELOG

For any user-observable change in a child repo, add a Keep-a-Changelog entry
to **that repo's** `CHANGELOG.md` under `## [Unreleased]` — not to the
workspace `CHANGELOG.md`. The workspace changelog records only changes to the
workspace wrapper itself.

| Repo | Has CHANGELOG? |
|------|---------------|
| `triage` | yes |
| `triage-action` | yes (when created) |
| `triage-secrets` | yes (when created) |

### 5. Commit in the child repo

Commits belong in the child repo's git history, not the workspace's. The
workspace gitignores all child directories. Do not stage child repo files
from the workspace root.

```bash
cd triage
git add .
git commit -m "fix: handle missing .go-version file gracefully"
```

### 6. Update specs in the child repo

If observable behavior changes, update the relevant spec under that repo's
`specs/` directory in the same PR — not in workspace-level docs (unless the
cross-repo estate map itself changes).

## Subagent delegation

When you delegate work to a subagent (e.g. via Cursor's Task tool), root the
subagent **inside the child repo's directory** so it picks up that repo's own
`AGENTS.md`, `.cursor/`, and context as if launched there directly.

```
# Correct: subagent sees triage's rules
Task(cwd="triage/", prompt="add --strict flag")

# Wrong: subagent operates at workspace root, misses child repo context
Task(cwd=".", prompt="add --strict flag to triage")
```

This prevents the common failure where a workspace-level agent treats the
workspace `AGENTS.md` as the only guidance and misses child-repo rules (e.g.
forgetting to update a CHANGELOG).

## Workspace-level work

Changes that belong in the workspace itself (this repo, not a child repo):

- Adding or removing a repo from the estate → update `repos.mk`, update
  `README.md` estate table, add a `CHANGELOG.md` entry here.
- Updating the workspace Makefile or manifest → `Makefile`, `repos.mk`.
- Updating cross-repo documentation → `README.md`.

For workspace-level commits, follow the same conventions as any child repo:
imperative mood, ≤72 chars, no period, no emojis.

## Don't do this

- **Don't run child tools from the workspace root.** `go build`, `golangci-lint`,
  etc. must run inside the relevant child repo.
- **Don't skip `make pre-commit` in a child repo before committing.** The
  workspace `make ci` is a convenience wrapper; the child repo's local gate is
  the definitive check.
- **Don't update a child repo's CONTRIBUTING.md, AGENTS.md, or specs from this
  workspace** unless you are explicitly auditing / patching cross-repo
  conventions (track such changes in the child repo's own git history).
- **Don't stage changes from multiple repos in one commit.** Each child repo
  has its own history.

## Toolchain pins

Toolchain pins live **per child repo**. The `make doctor` target delegates
to each child's own dogfood run.

| Tool | Pin file | `make doctor` in |
|------|----------|-----------------|
| Go | `triage/.go-version` | `triage/` |

Run `make doctor` to verify your local environment against these pins.

## For more detail

- Estate map, dependency diagram, per-repo purpose → [`README.md`](./README.md)
- Workspace targets reference → [`Makefile.md`](./Makefile.md)
- Working in the workspace → [`CONTRIBUTING.md`](./CONTRIBUTING.md)
- Working in a child repo → that repo's own `AGENTS.md`
