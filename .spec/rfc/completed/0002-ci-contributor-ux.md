# RFC 0002: CI and Contributor UX

| Field | Value |
|-------|-------|
| **Status** | Approved |
| **Author** | — |
| **Created** | 2026-07-26 |
| **Completed** | 2026-07-26 |
| **Depends on** | [RFC 0001](0001-linux-nix-flake-foundation.md) |
| **Supersedes** | — |

## Summary

Add GitHub Actions CI, `direnv` integration, and a `CONTRIBUTING.md` guide so contributors can validate flakes locally and in CI with minimal friction.

## Motivation

RFC 0001 established the flake foundation but deferred automation and onboarding docs. Without CI:

- Broken flakes can land on `main` undetected.
- Format drift accumulates across Nix files.
- New contributors lack a single entry point for commands and process.

## Proposal

### GitHub Actions CI

File: `.github/workflows/ci.yml`

| Step | Command | Purpose |
|------|---------|---------|
| Install Nix | `DeterminateSystems/nix-installer-action` | Reproducible Nix on runner |
| Cache | `DeterminateSystems/magic-nix-cache-action` | Faster builds |
| Check | `nix flake check` | Evaluate outputs on `x86_64-linux` |
| Format | `nix fmt --check .` | Enforce formatter |
| Build | `nix build` | Verify default package |

**Runner:** `ubuntu-latest` (`x86_64-linux` only).

### direnv

| File | Content |
|------|---------|
| `.envrc` | `use flake` |
| `nix/devshell.nix` | Includes `direnv` package |

### CONTRIBUTING.md

Documents prerequisites, common Nix commands, `flake.lock` updates, RFC process, and PR checklist.

### Formatter update

Replaced `nixfmt-rfc-style` with `pkgs.nixfmt`.

## Tasks

| ID | Task | Status |
|----|------|--------|
| T-0002-01 | Add `.github/workflows/ci.yml` | Done |
| T-0002-02 | Add `.envrc` with `use flake` | Done |
| T-0002-03 | Add `direnv` to dev shell | Done |
| T-0002-04 | Add `CONTRIBUTING.md` | Done |
| T-0002-05 | Switch formatter to `pkgs.nixfmt` | Done |
| T-0002-06 | Verify CI passes on push | Done |

## Acceptance criteria

- [x] RFC 0002 status is **Approved**
- [x] CI workflow runs `flake check`, `fmt --check`, and `build` on PR/push
- [x] `.envrc` loads dev shell via direnv
- [x] `CONTRIBUTING.md` covers Nix workflow and RFC process

## References

- [DeterminateSystems/nix-installer-action](https://github.com/DeterminateSystems/nix-installer-action)
- [direnv](https://direnv.net/)
