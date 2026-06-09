# Changelog

All notable changes to the triage-workspace wrapper are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Contributors append entries to `## [Unreleased]` as part of their PR; the
maintainer moves them into a new `## [vX.Y.Z]` section when cutting a release.

Changes to child repositories (`triage`, `triage-action`, etc.) belong in each
repo's own CHANGELOG.md, not here.

## [Unreleased]

### Added

- Registered `triage-action` in the workspace manifest (`repos.mk`), IDE workspace
  file, and estate table — the m6 composite action repo is now a first-class
  child of `triage-workspace`.
- Initial workspace scaffold: `Makefile` (`init`, `doctor`, `build`, `ci`,
  `pre-commit`, `clean`, `git-status`, `git-fetch`, `git-pull`, `git-push`),
  `repos.mk` manifest (triage live; triage-action and triage-secrets as
  commented placeholders), allowlist `.gitignore`, `README.md`, `AGENTS.md`,
  `CONTRIBUTING.md`, `Makefile.md`, and `triage.code-workspace`.
