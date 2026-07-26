# RFC 0001: Linux Nix Flake Foundation

| Field | Value |
|-------|-------|
| **Status** | Approved |
| **Author** | — |
| **Created** | 2026-07-26 |
| **Completed** | 2026-07-26 |
| **Supersedes** | — |

## Summary

Establish **cangjie** as a Linux-only Nix flake repository with a modular layout, reproducible inputs, a default development shell, and CI-ready formatting. This RFC defines the baseline structure before any application-specific packages or NixOS modules are added.

## Motivation

### Problem

The repository starts empty of design intent. Without a documented foundation:

- Contributors may add ad-hoc flake outputs or non-Linux targets inconsistently.
- Package logic will accumulate inline in `flake.nix`, becoming hard to maintain.
- There is no shared agreement on inputs, supported systems, or quality gates.

### Goals

1. **Linux-only** — support `x86_64-linux` and `aarch64-linux` only; no macOS or Windows flake outputs.
2. **Modular Nix** — keep `flake.nix` thin; delegate packages and shells to `nix/`.
3. **Reproducibility** — pin `nixpkgs` via `flake.lock`; document update workflow.
4. **Developer ergonomics** — `nix develop` provides common tooling out of the box.
5. **Formatting** — expose `nix fmt` via flake `formatter` output.

### Non-goals

- Packaging unrelated third-party languages (*cangjie* is a project codename only).
- NixOS modules, Home Manager modules, or overlays (deferred to future RFCs).
- Production application packages (placeholder only in Phase 0).
- CI automation (deferred to [RFC 0002](0002-ci-contributor-ux.md)).

## Proposal

### Repository layout

```
cangjie-nix/
├── flake.nix              # inputs + outputs wiring
├── flake.lock             # pinned inputs (generated)
├── .gitignore
├── ROADMAP.md
├── TASK_TRACKING.md
├── .spec/rfc/             # design documents (this tree)
└── nix/
    ├── packages.nix       # flake packages
    └── devshell.nix       # default dev shell
```

### Flake inputs

| Input | Source | Rationale |
|-------|--------|-----------|
| `nixpkgs` | `github:NixOS/nixpkgs/nixos-unstable` | Rolling Linux packages; pin in lockfile |
| `flake-utils` | `github:numtide/flake-utils` | `eachSystem` helper for multi-arch Linux |

### Flake outputs

| Output | Name | Description |
|--------|------|-------------|
| `packages` | `default` | Placeholder derivation until real packages land |
| `devShells` | `default` | Dev environment with `git`, `nixfmt`, `direnv` |
| `formatter` | — | `pkgs.nixfmt` for `nix fmt` |

### Supported systems

```nix
[ "x86_64-linux" "aarch64-linux" ]
```

## Tasks

| ID | Task | Status |
|----|------|--------|
| T-0001-01 | Create `flake.nix` with Linux-only systems | Done |
| T-0001-02 | Add `nix/packages.nix` placeholder | Done |
| T-0001-03 | Add `nix/devshell.nix` | Done |
| T-0001-04 | Add `.gitignore` for Nix artifacts | Done |
| T-0001-05 | Generate and commit `flake.lock` | Done |
| T-0001-06 | Verify `nix flake check` on Linux | Done |
| T-0001-07 | Verify `nix develop` and `nix build` | Done |

## Acceptance criteria

- [x] RFC 0001 status is **Approved**
- [x] `flake.lock` exists and is committed
- [x] `nix flake check` passes on Linux
- [x] `nix build` produces `result/bin/cangjie`
- [x] `nix develop` enters shell with expected packages
- [x] `nix fmt` runs without error

## References

- [Nix flake manual](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html)
- [numtide/flake-utils](https://github.com/numtide/flake-utils)
