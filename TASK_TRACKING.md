# Task Tracking — cangjie

Operational task list. Sync with [RFC 0001](docs/rfc/0001-linux-nix-flake-foundation.md) tasks.

## Legend

| Status | Meaning |
|--------|---------|
| To do | Queued |
| In progress | Active work |
| Done | Complete |
| Blocked | Waiting on dependency |

## Phase 0 — Foundation

| ID | Task | RFC | Status | Notes |
|----|------|-----|--------|-------|
| T-0001-01 | Create `flake.nix` with Linux-only systems | 0001 | Done | `x86_64-linux`, `aarch64-linux` |
| T-0001-02 | Add `nix/packages.nix` placeholder | 0001 | Done | |
| T-0001-03 | Add `nix/devshell.nix` | 0001 | Done | |
| T-0001-04 | Add `.gitignore` for Nix artifacts | 0001 | Done | |
| T-0001-05 | Generate and commit `flake.lock` | 0001 | To do | Needs Nix on Linux |
| T-0001-06 | Verify `nix flake check` on Linux | 0001 | To do | Blocked on T-0001-05 |
| T-0001-07 | Verify `nix develop` and `nix build` | 0001 | To do | Blocked on T-0001-05 |
| T-0001-08 | Add CI workflow | 0001 | To do | After T-0001-06 |

## Current focus

**`(CURRENT)`** T-0001-05 — generate `flake.lock` on a Linux host with Nix installed.
