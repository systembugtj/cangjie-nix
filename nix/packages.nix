{ pkgs }:

let
  gopdf = pkgs.callPackage ./gopdf.nix { };
  reasongraph = pkgs.callPackage ./reasongraph.nix { };
  issuegraph = pkgs.callPackage ./issuegraph.nix { };
  reviewgraph = pkgs.callPackage ./reviewgraph.nix { };
in
{
  inherit gopdf reasongraph issuegraph reviewgraph;
  default = gopdf;
}
