{
  lib,
  stdenvNoCC,
  fetchurl,
  nodejs,
  makeWrapper,
}:

stdenvNoCC.mkDerivation {
  pname = "brainstorm-server";
  version = "6.5.0";

  src = fetchurl {
    url = "https://github.com/borg0ai/designify/releases/download/v6.5.0/borg0ai-brainstorm-server-6.5.0.tgz";
    hash = "sha256-sgD5iQZlzf+ozkpebzb/6ftZmmyMcdtCeDKI6xHgnMc=";
  };
  sourceRoot = "package";

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/brainstorm-server/dist" "$out/bin"
    install -m644 dist/brainstorm.js "$out/lib/brainstorm-server/dist/brainstorm.js"
    install -Dm644 LICENSE "$out/share/licenses/brainstorm-server/LICENSE"
    makeWrapper "${nodejs}/bin/node" "$out/bin/brainstorm" \
      --add-flags "$out/lib/brainstorm-server/dist/brainstorm.js"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Local daemon for Designify visual companion screens";
    homepage = "https://github.com/borg0ai/designify";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "brainstorm";
  };
}
