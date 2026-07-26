# cangjie-nix

Linux Nix flake for **systembug** CLI packages.

## Packages

| Package | Upstream | Install |
|---------|----------|---------|
| **gopdf** | [gopdfjs/gopdf-cli](https://github.com/gopdfjs/gopdf-cli) | `nix profile install github:systembugtj/cangjie-nix#gopdf` |

## Quick start

```bash
# Build gopdf from this flake (Linux only)
nix build .#gopdf
./result/bin/gopdf --help

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

## Supported systems

- `x86_64-linux`
- `aarch64-linux`

## Related

- macOS: [luban-homebrew](https://github.com/systembugtj/luban-homebrew) — `brew install --HEAD systembugtj/luban-homebrew/gopdf`
- Spec: [RFC 0003](.spec/rfc/0003-gopdf-nix-package.md)
