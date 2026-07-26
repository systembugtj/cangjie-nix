{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    git
    nixfmt
    direnv
  ];

  shellHook = ''
    echo "cangjie dev shell (Linux flake)"
  '';
}
