# Task Tracking — cangjie

Operational task list. Completed RFCs archived under [`.spec/rfc/completed/`](.spec/rfc/completed/).

## Legend

| Status | Meaning |
|--------|---------|
| To do | Queued |
| In progress | Active work |
| Done | Complete |
| Blocked | Waiting on dependency |

## Phase 0 — Foundation (RFC 0001) ✓

| ID | Task | Status |
|----|------|--------|
| T-0001-01 | Create `flake.nix` with Linux-only systems | Done |
| T-0001-02 | Add `nix/packages.nix` placeholder | Done |
| T-0001-03 | Add `nix/devshell.nix` | Done |
| T-0001-04 | Add `.gitignore` for Nix artifacts | Done |
| T-0001-05 | Generate and commit `flake.lock` | Done |
| T-0001-06 | Verify `nix flake check` on Linux | Done |
| T-0001-07 | Verify `nix develop` and `nix build` | Done |

## Phase 1 — CI & contributor UX (RFC 0002) ✓

| ID | Task | Status |
|----|------|--------|
| T-0002-01 | Add `.github/workflows/ci.yml` | Done |
| T-0002-02 | Add `.envrc` with `use flake` | Done |
| T-0002-03 | Add `direnv` to dev shell | Done |
| T-0002-04 | Add `CONTRIBUTING.md` | Done |
| T-0002-05 | Switch formatter to `pkgs.nixfmt` | Done |
| T-0002-06 | Verify CI passes on push | Done |

## Phase 2 — gopdf package (RFC 0003)

| ID | Task | Status |
|----|------|--------|
| T-0003-01 | Add `nix/gopdf.nix` | Done |
| T-0003-02 | Wire `packages.gopdf` + `default` | Done |
| T-0003-03 | Verify `nix build .#gopdf` on Linux | Done |
| T-0003-04 | CI builds `gopdf` | To do |
| T-0003-05 | gopdf-cli site documents Nix install | To do |

## Current focus

**`(CURRENT)`** T-0003-04 — push cangjie-nix and confirm CI builds `gopdf`.
