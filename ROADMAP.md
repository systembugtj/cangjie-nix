# cangjie Roadmap

Project codename **cangjie** — Linux Nix flake repository.

## Phases

### Phase 0 — Foundation ✓

**RFC:** [0001 Linux Nix Flake Foundation](.spec/rfc/completed/0001-linux-nix-flake-foundation.md)

| Milestone | Status |
|-----------|--------|
| RFC 0001 approved | Done |
| Flake scaffold + `flake.lock` | Done |
| `nix flake check` / `nix build` verified | Done |

### Phase 1 — CI & contributor UX ✓

**RFC:** [0002 CI and Contributor UX](.spec/rfc/completed/0002-ci-contributor-ux.md)

| Milestone | Status |
|-----------|--------|
| GitHub Actions CI | Done |
| `direnv` + `.envrc` | Done |
| `CONTRIBUTING.md` | Done |

### Phase 2 — Packages (in progress)

- **gopdf** — [RFC 0003](.spec/rfc/0003-gopdf-nix-package.md) (`nix/gopdf.nix`)
- Overlays or package sets as needed

| Milestone | Target | Status |
|-----------|--------|--------|
| RFC 0003 drafted | 2026-07-26 | Done |
| `packages.gopdf` derivation | 2026-07-26 | Done |
| `nix build .#gopdf` smoke test | 2026-07-26 | Done |
| CI builds `gopdf` | TBD | Pending |

## RFC register

| RFC | Title | Status | Phase |
|-----|-------|--------|-------|
| 0001 | Linux Nix Flake Foundation | Approved | 0 |
| 0002 | CI and Contributor UX | Approved | 1 |
| 0003 | gopdf Nix Package | Draft | 2 |
