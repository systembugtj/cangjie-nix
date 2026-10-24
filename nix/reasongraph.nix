{
  lib,
  stdenvNoCC,
  fetchurl,
  nodejs,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "reasongraph";
  version = "0.2.4";

  # Release tarball from `npm pack`; it unpacks to `package/`.
  src = fetchurl {
    url = "https://github.com/borg0ai/dx-reasongraph/releases/download/v${finalAttrs.version}/borg0ai-reasongraph-${finalAttrs.version}.tgz";
    hash = "sha256-1XBU0WSpFaDj1OatbBvYmE57+vU/doTahVcpEiQ5IaE=";
  };

  sourceRoot = "package";

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/reasongraph" "$out/bin"
    cp -r dist package.json "$out/lib/reasongraph/"
    makeWrapper "${nodejs}/bin/node" "$out/bin/reasongraph" \
      --add-flags "$out/lib/reasongraph/dist/cli.js"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Repository decision history CLI for coding agents";
    homepage = "https://github.com/borg0ai/dx-reasongraph";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "reasongraph";
  };
})
