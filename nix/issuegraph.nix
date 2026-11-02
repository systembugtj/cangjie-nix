{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "1.3.3";
  base = "https://github.com/borg0ai/dx-issuegraph/releases/download/v${version}";
  sources = {
    x86_64-linux = fetchurl {
      url = "${base}/issuegraph_${version}_linux-amd64.tar.gz";
      hash = "sha256-bwSVdfxUfiZeA29Tm+8ApiYa5w9iWEtAPans4+/HqqI=";
    };
    aarch64-linux = fetchurl {
      url = "${base}/issuegraph_${version}_linux-arm64.tar.gz";
      hash = "sha256-yclqHZAwD3eN9yDhHBNyQtP0Hy/kBYZcIXQGgpj4x9w=";
    };
  };
in
stdenv.mkDerivation {
  pname = "issuegraph";
  inherit version;

  src = sources.${stdenv.hostPlatform.system};
  sourceRoot = ".";

  # cgo build with embedded Dolt: dynamically linked against glibc only.
  nativeBuildInputs = [ autoPatchelfHook ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 issuegraph "$out/bin/issuegraph"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Git-tracked issue graph CLI for coding agents";
    homepage = "https://github.com/borg0ai/dx-issuegraph";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "issuegraph";
  };
}
