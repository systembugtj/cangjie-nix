# cangjie-nix

Linux Nix flake for **systembug** applications.

## Packages

| Package | Upstream | Install |
|---------|----------|---------|
| **gopdf** | [gopdfjs/gopdf-cli](https://github.com/gopdfjs/gopdf-cli) | `nix profile install github:systembugtj/cangjie-nix#gopdf` |
| **reasongraph** | [borg0ai/dx-reasongraph](https://github.com/borg0ai/dx-reasongraph) | `nix profile install github:systembugtj/cangjie-nix#reasongraph` |
| **Ghostty** | [matrix0ai/dx-qingluan](https://github.com/matrix0ai/dx-qingluan) | `nix profile install github:systembugtj/cangjie-nix#ghostty` |
| **libghostty-vt** | [matrix0ai/dx-qingluan](https://github.com/matrix0ai/dx-qingluan) | `nix profile install github:systembugtj/cangjie-nix#libghostty-vt` |

## Quick start

```bash
# Build gopdf from this flake (Linux only)
nix build .#gopdf
./result/bin/gopdf --help

# Build Ghostty and its terminal library
nix build .#ghostty .#libghostty-vt

# Or install into user profile
nix profile install .#gopdf
```

## First-time maintainer setup

On a Linux host with Nix installed:

```bash
nix flake update          # generate / refresh flake.lock
nix build .#gopdf         # fix src + pnpmDeps hashes (see build log)
nix flake check
nix fmt
```

Hash bumps when upstream `gopdf-cli` changes — update `srcRev` in `nix/gopdf.nix`.

## Ghostty source pin and GitHub Release

Ghostty's Nix expressions live in `nix/ghostty/`; the root flake exposes their
packages and development shells. Update the `ghostty-src` revision in the root
`flake.nix`, then regenerate the lock file with `nix flake lock`. Package
versions derive their revision suffix from that pinned input.
Keep the source revision and generated lock file in the same cangjie-nix commit.

CI builds Ghostty and libghostty-vt on `x86_64-linux` and `aarch64-linux`.
Before publishing, confirm both builds pass on the commit that pins the intended
Ghostty source. Then create a versioned release from that cangjie-nix commit:

```bash
git rev-parse HEAD
gh release create "ghostty-v${VERSION}" --target "${CANGJIE_COMMIT}" \
  --title "Ghostty ${VERSION}" --generate-notes
```

Set `VERSION` to the Ghostty version from the pinned source and
`CANGJIE_COMMIT` to the verified cangjie-nix commit. This command creates a
public GitHub Release when run. Release preparation does not upload binaries.

## Supported systems

- `x86_64-linux`
- `aarch64-linux`

## Related

- macOS: [luban-homebrew](https://github.com/systembugtj/luban-homebrew) — `brew install --HEAD systembugtj/luban-homebrew/gopdf`
- Spec: [RFC 0003](.spec/rfc/0003-gopdf-nix-package.md)
