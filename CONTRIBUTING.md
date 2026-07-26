# Contributing to cangjie

**cangjie** is a Linux-only Nix flake repository (project codename).

## Prerequisites

- [Nix](https://nixos.org/download/) with flakes enabled
- Optional: [direnv](https://direnv.net/) for automatic shell activation

## Quick start

```bash
# Enter dev shell (manual)
nix develop

# Or with direnv (after: direnv allow)
direnv allow
```

## Common commands

| Command | Purpose |
|---------|---------|
| `nix flake check` | Evaluate all flake outputs |
| `nix build` | Build `packages.default` |
| `nix develop` | Enter development shell |
| `nix fmt .` | Format Nix files |
| `nix fmt . && git diff --exit-code` | Verify formatting (CI) |

## Updating dependencies

```bash
nix flake update          # refresh inputs
nix flake lock --update-input nixpkgs   # update nixpkgs only
```

Commit `flake.lock` with the change.

## RFC process

Design changes require an RFC under [`.spec/rfc/`](.spec/rfc/README.md):

1. Draft RFC as `NNNN-short-slug.md`
2. Register in [`ROADMAP.md`](ROADMAP.md) and [`TASK_TRACKING.md`](TASK_TRACKING.md)
3. Get approval before large scope changes
4. Archive completed RFCs to `.spec/rfc/completed/`

## Supported platforms

This flake targets Linux only:

- `x86_64-linux`
- `aarch64-linux`

CI runs on `x86_64-linux` (GitHub Actions `ubuntu-latest`).

## Pull requests

1. Branch from `main`
2. Run `nix flake check` and `nix fmt` locally (or rely on CI)
3. Update RFC / task tracker if scope changes
4. Open PR with a clear summary
