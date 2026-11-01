{
  description = "cangjie — Linux Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    systems = {
      url = "github:nix-systems/default";
      flake = false;
    };

    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        systems.follows = "systems";
      };
    };

    zon2nix = {
      url = "github:jcollie/zon2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty-src = {
      url = "github:matrix0ai/dx-qingluan/51fb536db4190076645b35612d6694ad6b74d329";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      zig,
      zon2nix,
      home-manager,
      ghostty-src,
      ...
    }:
    let
      lib = nixpkgs.lib;
      ghostty = import ./nix/ghostty/outputs.nix {
        inherit
          self
          nixpkgs
          zig
          zon2nix
          home-manager
          ghostty-src
          ;
      };
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      linuxOutputs = flake-utils.lib.eachSystem systems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          packages = import ./nix/packages.nix { inherit pkgs; };
          ghosttyPackages = ghostty.packages.${system};
        in
        {
          packages =
            packages
            // (builtins.removeAttrs ghosttyPackages [
              "default"
              "deps"
            ])
            // {
              default = packages.default;
              ghostty = ghosttyPackages.ghostty;
              ghostty-deps = ghosttyPackages.deps;
            };

          devShells = {
            default = import ./nix/devshell.nix { inherit pkgs; };
            ghostty = ghostty.devShells.${system}.default;
            ghostty-fuzz = ghostty.devShells.${system}.fuzz;
          };

          checks = ghostty.checks.${system};
          apps = ghostty.apps.${system};
          formatter = pkgs.nixfmt;
        }
      );
      darwinSystems = lib.filter (system: builtins.hasAttr system ghostty.devShells) [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      darwinShells = lib.genAttrs darwinSystems (system: {
        ghostty = ghostty.devShells.${system}.default;
      });
    in
    lib.recursiveUpdate linuxOutputs {
      devShells = darwinShells;
      overlays = ghostty.overlays;
      nixConfig = {
        extra-substituters = [ "https://ghostty.cachix.org" ];
        extra-trusted-public-keys = [
          "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
        ];
      };
    };
}
