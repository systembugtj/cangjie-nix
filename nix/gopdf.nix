{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  makeWrapper,
}:

let
  # Pin upstream until @gopdfjs/pdf-cli is on npm; bump on release tags.
  srcRev = "a341f251b070f4acf5f94c43f32a4e6a964a369a";

  src = fetchFromGitHub {
    owner = "gopdfjs";
    repo = "gopdf-cli";
    rev = srcRev;
    hash = "sha256-ndq5yjv7EcIMA5OuF3if99X4FRWTQ6uAqoBslloiLzQ=";
  };

  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gopdf";
  version = "0.1.0";

  inherit src;

  pnpmWorkspaces = [
    "@gopdfjs/pdf-cli"
    "@gopdf-cli/setup"
  ];

  pnpmInstallFlags = [ "--shamefully-hoist" ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src pnpmWorkspaces pnpmInstallFlags;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-+yOlh3DmJPcTjkmPTgmR4KEwdTdi4Jk8qmHqXglzwG0=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild
    pnpm --filter @gopdfjs/pdf-cli run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/dist" "$out/bin"
    cp -r apps/cli/dist/. "$out/dist/"
    cp apps/cli/package.json "$out/package.json"
    cp -rL node_modules "$out/node_modules"

    makeWrapper "${nodejs}/bin/node" "$out/bin/gopdf" \
      --add-flags "$out/dist/index.mjs"
    ln -s gopdf "$out/bin/gopdf-cli"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Local PDF CLI — compress, analyze, OCR, MCP (gopdf-cli)";
    homepage = "https://github.com/gopdfjs/gopdf-cli";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "gopdf";
  };
})
