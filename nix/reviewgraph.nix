{
  lib,
  python3Packages,
  fetchurl,
}:

let
  version = "2.4.0";
  base = "https://github.com/borg0ai/dx-reviewgraph/releases/download/v${version}";

  # Release wheels; dependencies come from nixpkgs, not from PyPI.
  engine = python3Packages.buildPythonPackage {
    pname = "reviewgraph-engine";
    inherit version;
    format = "wheel";
    src = fetchurl {
      url = "${base}/reviewgraph_engine-${version}-py3-none-any.whl";
      hash = "sha256-nuHbYL5bO4TtYaC2VH+tXY4X3Dj/wkyBNVwIQN5auc0=";
    };
    pythonRelaxDeps = true;
    dependencies = with python3Packages; [
      mcp
      fastmcp
      anyio
      tree-sitter
      tree-sitter-language-pack
      pyyaml
      networkx
      watchdog
    ];
  };
in
python3Packages.buildPythonApplication {
  pname = "reviewgraph";
  inherit version;
  format = "wheel";

  src = fetchurl {
    url = "${base}/reviewgraph-${version}-py3-none-any.whl";
    hash = "sha256-BVHnrVbmK88gM10fE4ZwzFZYoueq4ZTnGOsaGfdw6yc=";
  };

  pythonRelaxDeps = true;
  dependencies = [
    engine
    python3Packages.rich
  ];

  meta = with lib; {
    description = "Local-first code review knowledge graph and MCP server";
    homepage = "https://github.com/borg0ai/dx-reviewgraph";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "reviewgraph";
  };
}
