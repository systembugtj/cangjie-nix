{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    git
    nixfmt-rfc-style
  ];

  shellHook = ''
    echo "cangjie dev shell (Linux flake)"
  '';
}
