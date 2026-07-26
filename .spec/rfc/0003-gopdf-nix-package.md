# RFC 0003: gopdf Nix Package

| Field | Value |
|-------|-------|
| **Status** | Draft |
| **Author** | — |
| **Created** | 2026-07-26 |
| **Related** | [gopdf-cli RFC 0003](https://github.com/gopdfjs/gopdf-cli/blob/main/.spec/rfc/0003-homebrew-formula.md), [luban-homebrew RFC 002](https://github.com/systembugtj/luban-homebrew/blob/main/.spec/rfc/002-gopdf-formula.md) |

## Summary

Package **[gopdf-cli](https://github.com/gopdfjs/gopdf-cli)** as `packages.gopdf` in the cangjie flake (Linux). Mirrors luban-homebrew HEAD strategy: pnpm monorepo build + self-contained runtime tree.

## Install

```bash
nix build github:systembugtj/cangjie-nix#gopdf
nix profile install github:systembugtj/cangjie-nix#gopdf
```

## Derivation

| File | Role |
|------|------|
| `nix/gopdf.nix` | `fetchFromGitHub` + `fetchPnpmDeps` + vite build + `node_modules` copy |
| `nix/packages.nix` | exports `gopdf` and `default = gopdf` |

## Build strategy (until npm publish)

1. Pin `srcRev` in `nix/gopdf.nix` to a `gopdf-cli` commit
2. `fetchPnpmDeps` with `pnpmWorkspaces = [ "@gopdfjs/pdf-cli" "@gopdf-cli/setup" ]`
3. `pnpmInstallFlags = [ "--shamefully-hoist" ]` for a flat `node_modules` tree
4. `pnpm --filter @gopdfjs/pdf-cli run build`
5. Copy `apps/cli/dist` + `node_modules` into `$out`; wrap `gopdf` / `gopdf-cli` bins

Vite externalizes `@gopdfjs/*` and MCP deps — runtime `node_modules` is required (same constraint as Homebrew).

## Version sync

| Event | Action |
|-------|--------|
| `gopdf-cli` release | Bump `srcRev`, refresh `src` hash + `pnpmDeps` hash |
| `@gopdfjs/pdf-cli` on npm | Future RFC: `buildNpmPackage` from registry tarball |

## Tasks

| ID | Task | Status |
|----|------|--------|
| T-0003-01 | Add `nix/gopdf.nix` | Done |
| T-0003-02 | Wire `packages.gopdf` + `default` | Done |
| T-0003-03 | Verify `nix build .#gopdf` on Linux | Done |
| T-0003-04 | CI builds `gopdf` | To do |
| T-0003-05 | gopdf-cli site documents Nix install | To do |

## Acceptance criteria

- [x] `nix build .#gopdf` succeeds on `x86_64-linux`
- [x] `./result/bin/gopdf --help` works
- [ ] CI builds `gopdf` on push
- [ ] gopdf-cli installation guide lists cangjie-nix
