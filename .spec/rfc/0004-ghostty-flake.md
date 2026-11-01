# RFC 0004: Ghostty Linux Package and Release

| Field | Value |
|-------|-------|
| **Status** | Approved |
| **Author** | — |
| **Created** | 2026-10-25 |
| **Related** | Ghostty repository RFC 0005: Move Ghostty Nix packaging to cangjie-nix |

## Summary

Add Ghostty and libghostty-vt packages to the cangjie-nix root package registry for `x86_64-linux` and `aarch64-linux`. Keep per-app build logic in `nix/ghostty/`, and keep gopdf and reasongraph packages unchanged. Document manual GitHub Releases through `gh release`.

## Motivation

cangjie-nix releases Linux applications from one repository. Ghostty's Nix definitions currently live in the Ghostty source repository and cannot be moved alone because their paths depend on its root flake and Zig dependency map. Importing those definitions here makes cangjie-nix the package and release authority for Ghostty.

## Proposal

Move Ghostty's Nix expressions into `nix/ghostty/outputs.nix` and keep the root flake as the only flake. Import Ghostty outputs from the root flake and add a pinned Ghostty source input. Forward `packages.ghostty`, optimization variants, `packages.libghostty-vt`, its variants, `packages.ghostty-deps`, `devShells.ghostty`, and `devShells.ghostty-fuzz` through the existing root registry. Keep `packages.default` set to `gopdf`.

Support `x86_64-linux` and `aarch64-linux` packages. Keep development shells available for Zig-supported macOS systems for Ghostty source CI. Preserve current package build flags, platform limits, tools, overlays, checks, and VM apps.

Extend cangjie-nix CI to build Ghostty packages on both supported Linux architectures. Do not add Nix package CI to the Ghostty source repository. Add README instructions for updating the pinned Ghostty source and publishing a versioned GitHub Release with `gh release create`. Build the package for both architectures before release. A release points to the cangjie-nix commit that pins the matching Ghostty source revision. GitHub's generated source archives provide release downloads; this RFC does not publish binary assets or create a release.

## Alternatives

1. Move Ghostty expressions into the shared `nix/` directory. This mixes Ghostty-specific dependencies and checks with unrelated app packages.
2. Keep Ghostty build logic isolated under `nix/ghostty/` and forward its package outputs through the root flake. This gives users one app registry and release path. Recommended.

## Tasks

| ID | Task | Status |
|----|------|--------|
| T-0004-01 | Move Ghostty Nix expressions under `nix/ghostty/` | Done |
| T-0004-02 | Add Ghostty source input, package outputs, and dev shells | Done |
| T-0004-03 | Extend cangjie CI to build Ghostty packages | Done |
| T-0004-04 | Document manual multi-architecture `gh release` process | Done |
| T-0004-05 | Build and inspect Ghostty packages on both Linux architectures | In progress |

## Acceptance criteria

- Root flake exposes Ghostty and libghostty-vt packages for both supported Linux architectures.
- Existing gopdf, reasongraph, and default outputs remain unchanged.
- `nix flake check` and package builds succeed on supported Linux hosts.
- Cangjie-nix CI builds Ghostty packages for both supported Linux architectures.
- Ghostty source CI contains no Nix package build job.
- README documents source pin updates, package installation, and manual `gh release` steps.
- No GitHub Release is created as part of this RFC.
