{
  description = "cangjie — Linux Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          packages = import ./nix/packages.nix { inherit pkgs; };
        in
        {
          packages = packages // {
            default = packages.default;
          };

          devShells.default = import ./nix/devshell.nix { inherit pkgs; };

          formatter = pkgs.nixfmt;
        }
      );
}
