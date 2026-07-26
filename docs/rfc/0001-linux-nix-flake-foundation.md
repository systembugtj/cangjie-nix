# RFC 0001: Linux Nix Flake Foundation

| Field | Value |
|-------|-------|
| **Status** | Draft |
| **Author** | — |
| **Created** | 2026-07-26 |
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

- Packaging the Cangjie programming language (unrelated; *cangjie* is a project codename only).
- NixOS modules, Home Manager modules, or overlays (deferred to future RFCs).
- Production application packages (placeholder only in Phase 0).

## Proposal

### Repository layout

```
cangjie-nix/
├── flake.nix              # inputs + outputs wiring
├── flake.lock             # pinned inputs (generated)
├── .gitignore
├── ROADMAP.md
├── TASK_TRACKING.md
├── docs/rfc/              # design documents (this tree)
└── nix/
    ├── packages.nix       # flake packages
    └── devshell.nix       # default dev shell
```

### Flake inputs

| Input | Source | Rationale |
|-------|--------|-----------|
| `nixpkgs` | `github:NixOS/nixpkgs/nixos-unstable` | Rolling Linux packages; pin in lockfile |
| `flake-utils` | `github:numtide/flake-utils` | `eachSystem` helper for multi-arch Linux |

**Alternative considered:** pure `lib.genAttrs` without `flake-utils`. Rejected for Phase 0 — `flake-utils` is widely understood and keeps `flake.nix` short. May revisit in a later RFC.

### Flake outputs

| Output | Name | Description |
|--------|------|-------------|
| `packages` | `default` | Placeholder derivation until real packages land |
| `devShells` | `default` | Dev environment with `git`, `nixfmt-rfc-style` |
| `formatter` | — | `nixfmt-rfc-style` for `nix fmt` |

### Supported systems

```nix
[ "x86_64-linux" "aarch64-linux" ]
```

No `eachDefaultSystem` — explicitly Linux-only to avoid accidental Darwin CI or local macOS builds.

### Development shell

`nix/devshell.nix` provides:

- `git` — version control
- `nixfmt-rfc-style` — RFC-style Nix formatting

Shell hook prints a short banner so users know they entered the cangjie dev shell.

### Packages

`nix/packages.nix` exports a `default` placeholder (`writeShellScriptBin "cangjie"`) until RFC 0002+ defines real derivations.

### Quality gates (Phase 0)

| Check | Command | When |
|-------|---------|------|
| Flake evaluates | `nix flake check` | Local + CI |
| Format | `nix fmt` | Pre-commit / CI |
| Lockfile present | `flake.lock` committed | After first `nix flake update` |

### CI (future, out of RFC 0001 scope)

Document intent only: GitHub Actions on `x86_64-linux` running `nix flake check` and `nix fmt --check`. Implementation tracked separately.

## Risks and mitigations

| Risk | Mitigation |
|------|------------|
| `nixos-unstable` breaks builds | Pin lockfile; document `nix flake update` policy |
| Scope creep into NixOS/app packaging | Require new RFC per major output type |
| No Nix on contributor machines | Document install via [nixos.org/download](https://nixos.org/download/) |

## Tasks

| ID | Task | Owner | Status |
|----|------|-------|--------|
| T-0001-01 | Create `flake.nix` with Linux-only systems | — | Done |
| T-0001-02 | Add `nix/packages.nix` placeholder | — | Done |
| T-0001-03 | Add `nix/devshell.nix` | — | Done |
| T-0001-04 | Add `.gitignore` for Nix artifacts | — | Done |
| T-0001-05 | Generate and commit `flake.lock` | — | To do |
| T-0001-06 | Verify `nix flake check` on Linux | — | To do |
| T-0001-07 | Verify `nix develop` and `nix build` | — | To do |
| T-0001-08 | Add CI workflow (`flake check` + `fmt`) | — | To do |

## Acceptance criteria

- [ ] RFC 0001 status is **Approved**
- [ ] `flake.lock` exists and is committed
- [ ] `nix flake check` passes on `x86_64-linux`
- [ ] `nix build` produces `result/bin/cangjie`
- [ ] `nix develop` enters shell with expected packages
- [ ] `nix fmt` runs without error

## Open questions

1. Should CI also run on `aarch64-linux` (QEMU / self-hosted runner)?
2. Pin `nixpkgs` to a release branch instead of `nixos-unstable`?
3. Add `direnv` + `flake.nix` integration in a follow-up RFC?

## References

- [Nix flake manual](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html)
- [numtide/flake-utils](https://github.com/numtide/flake-utils)
