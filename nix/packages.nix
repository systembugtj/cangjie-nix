{ pkgs }:

let
  gopdf = pkgs.callPackage ./gopdf.nix { };
  reasongraph = pkgs.callPackage ./reasongraph.nix { };
  issuegraph = pkgs.callPackage ./issuegraph.nix { };
in
{
  inherit gopdf reasongraph issuegraph;
  default = gopdf;
}
