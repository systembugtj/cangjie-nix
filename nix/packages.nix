{ pkgs }:

let
  gopdf = pkgs.callPackage ./gopdf.nix { };
in
{
  inherit gopdf;
  default = gopdf;
}
