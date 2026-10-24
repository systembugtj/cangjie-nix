{ pkgs }:

let
  gopdf = pkgs.callPackage ./gopdf.nix { };
  reasongraph = pkgs.callPackage ./reasongraph.nix { };
in
{
  inherit gopdf reasongraph;
  default = gopdf;
}
