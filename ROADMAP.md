# cangjie Roadmap

Project codename **cangjie** — Linux Nix flake repository.

## Phases

### Phase 0 — Foundation (current)

**RFC:** [0001 Linux Nix Flake Foundation](docs/rfc/0001-linux-nix-flake-foundation.md)

Establish flake skeleton, dev shell, formatter, and lockfile. No application packages yet.

| Milestone | Target | Status |
|-----------|--------|--------|
| RFC 0001 drafted | 2026-07-26 | Done |
| Flake scaffold | 2026-07-26 | Done |
| `flake.lock` + `nix flake check` | TBD | Pending |
| CI (`flake check`, `fmt`) | TBD | Pending |

### Phase 1 — CI & contributor UX (planned)

- GitHub Actions on Linux
- Optional `direnv` / `.envrc`
- CONTRIBUTING with Nix workflow

*Requires RFC 0002 (not yet authored).*

### Phase 2 — Packages (planned)

- Real derivations replacing placeholder `packages.default`
- Overlays or package sets as needed

*Requires RFC 0003+ (not yet authored).*

## RFC register

| RFC | Title | Status | Phase |
|-----|-------|--------|-------|
| 0001 | Linux Nix Flake Foundation | Draft | 0 |
