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

### Phase 2 — Packages (planned)

- Real derivations replacing placeholder `packages.default`
- Overlays or package sets as needed

*Requires RFC 0003+ (not yet authored).*

## RFC register

| RFC | Title | Status | Phase |
|-----|-------|--------|-------|
| 0001 | Linux Nix Flake Foundation | Approved | 0 |
| 0002 | CI and Contributor UX | Approved | 1 |
