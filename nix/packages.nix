{ pkgs }:

let
  gopdf = pkgs.callPackage ./gopdf.nix { };
  reasongraph = pkgs.callPackage ./reasongraph.nix { };
  issuegraph = pkgs.callPackage ./issuegraph.nix { };
  brainstorm-server = pkgs.callPackage ./brainstorm-server.nix { };
in
{
  inherit gopdf reasongraph issuegraph brainstorm-server;
  default = gopdf;
}
