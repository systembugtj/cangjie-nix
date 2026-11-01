{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "1.3.2";
  base = "https://github.com/borg0ai/dx-issuegraph/releases/download/v${version}";
  sources = {
    x86_64-linux = fetchurl {
      url = "${base}/issuegraph_${version}_linux-amd64.tar.gz";
      hash = "sha256-6cy7Oav3wxmm4l5q2rqI6oEUQRQgWizjM63LpDBxrk8=";
    };
    aarch64-linux = fetchurl {
      url = "${base}/issuegraph_${version}_linux-arm64.tar.gz";
      hash = "sha256-664HN0OtTdfEtFmQoU4dM1ZXa91/EJw6iYqCZh9voU0=";
    };
  };
in
stdenv.mkDerivation {
  pname = "issuegraph";
  inherit version;

  src = sources.${stdenv.hostPlatform.system};
  sourceRoot = ".";

  # Static Go binary (CGO_ENABLED=0): no autoPatchelf needed.
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
