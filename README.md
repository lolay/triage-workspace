# triage-workspace

Developer-friendly wrapper for the [triage](https://github.com/lolay/triage)
multi-repo estate. It clones and initialises all repos, documents their
relationships, and provides cross-repo `make` targets for the daily
`build / ci / git-fetch / git-status` loop.

> **The workspace is optional.** Every child repo (`triage/`, etc.) is fully
> usable on its own — nothing in a child repo depends on this workspace. Clone
> any individual repo and follow its own `README.md`.

## Quick start

```bash
git clone git@github.com:lolay/triage-workspace.git
cd triage-workspace
make init      # clone missing repos + run per-repo make init + make doctor
make doctor    # health check: repo roster + system tools
```

## The estate

| Repo | Purpose | Stack | Status |
|------|---------|-------|--------|
| [`lolay/triage`](https://github.com/lolay/triage) | Environment doctor CLI — reads `triage.yaml` and reports missing tools, versions, env vars, files, and auth probes | Go | Active |
| `lolay/triage-action` | GitHub Action wrapper — installs the `triage` CLI from release assets and runs a profile; Marketplace-eligible composite action | bash | Planned (m6) |
| `lolay/triage-secrets` | Git-style plugin for secret/credential readiness checks (`triage-secrets` on `PATH`) | TBD | Planned |

## Dependency map

```
triage  ──(release assets)──►  triage-action
        ──(triage-NAME plugin)──►  triage-secrets
```

Build order for `make build`: `triage` only (it produces the binary; action and
secrets repos have no build step, only lint/test).

## Workspace targets

```bash
make help          # list all targets
make init          # clone missing repos + per-repo make init + doctor
make doctor        # read-only: repo roster + system tool versions
make build         # make build in dependency order
make ci            # make ci in each repo (dumb pass-through)
make pre-commit    # make pre-commit in each repo (dumb pass-through)
make clean         # make clean in repos that define the target
make git-status    # git status -s across all repos
make git-fetch     # git fetch across all repos (observe-only)
make git-pull      # git pull --ff-only across all repos (skips dirty/diverged)
make git-push      # git push across all repos (warns on failure)
```

See [`Makefile.md`](./Makefile.md) for the full narrative reference.

## Working on a single repo

The workspace is a convenience layer. To work on one repo independently:

```bash
cd triage       # or any other repo directory
make help       # that repo's targets
make init       # that repo's init
make ci         # that repo's gate
```

Each repo's `AGENTS.md`, `CONTRIBUTING.md`, and `Makefile` are the source
of truth for working inside it.

## Worktrees

Worktrees for child repos are created as **siblings** of the main checkout
inside this workspace root. The workspace `.gitignore` uses an allowlist
strategy (`/*` + selective un-ignores) that covers all worktrees automatically:

```bash
# Create a worktree for branch feat/foo in triage:
git -C triage worktree add ../triage-foo -b feat/foo
# triage-foo/ lands next to triage/ and is automatically gitignored here
```

Naming convention: `<repo>-<branch-slug>` (type prefix stripped). See
[CONTRIBUTING.md](./CONTRIBUTING.md) for details.

## Prerequisites

Run `make doctor` to check. Required: `git`, `gh`, `go` (pin in
`triage/.go-version`). Optional: `goreleaser` (release builds), `golangci-lint`
(lint; CI always runs it).
