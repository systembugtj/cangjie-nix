{
  self,
  nixpkgs,
  zig,
  zon2nix,
  home-manager,
  ghostty-src,
  ...
}:
let
  inherit (nixpkgs) lib legacyPackages;

  # Our supported systems are the same supported systems as the Zig binaries.
  platforms = lib.attrNames zig.packages;

  # Backport https://codeberg.org/ziglang/zig/commit/0bfd34342b so
  # cross-compiling C/C++ sources for iOS doesn't instantiate unsupported
  # process spawning code in Zig 0.17's standard library.
  zig_0_17 =
    system:
    zig.packages.${system}."0.17.0".overrideAttrs (previousAttrs: {
      patches = (previousAttrs.patches or [ ]) ++ [
        ./nix/patches/zig-0.17-ios-process-replace.patch
      ];
    });

  # It's not always possible to build Ghostty with Nix for each system,
  # one such example being macOS due to missing Swift 6 and xcodebuild
  # support in the Nix ecosystem. Therefore for things like package outputs
  # we need to limit the attributes we expose.
  buildablePlatforms = lib.filter (p: !(lib.systems.elaborate p).isDarwin) platforms;

  forAllPlatforms = f: lib.genAttrs platforms (s: f legacyPackages.${s});
  forBuildablePlatforms = f: lib.genAttrs buildablePlatforms (s: f legacyPackages.${s});

  mkPkgArgs = pkgs: optimize: {
    inherit optimize;
    zig_0_17 = zig_0_17 pkgs.stdenv.hostPlatform.system;
    zigBuildHook = pkgs.makeSetupHook { name = "zig-build-hook"; } pkgs.zig.setupHook;
    ghosttySrc = /. + builtins.unsafeDiscardStringContext (lib.removePrefix "/" (toString ghostty-src));
    revision = if ghostty-src ? rev then builtins.substring 0 8 ghostty-src.rev else "dirty";
  };
in
{
  devShells = forAllPlatforms (
    pkgs:
    let
      args = {
        zig = zig_0_17 pkgs.stdenv.hostPlatform.system;
        wraptest = pkgs.callPackage ./nix/pkgs/wraptest.nix { };
        zon2nix = zon2nix;

        python3 = pkgs.python3.override {
          self = pkgs.python3;
          packageOverrides = pyfinal: pyprev: {
            blessed = pyfinal.callPackage ./nix/pkgs/blessed.nix { };
            ucs-detect = pyfinal.callPackage ./nix/pkgs/ucs-detect.nix { };
            wcwidth = pyfinal.callPackage ./nix/pkgs/wcwidth.nix { };
          };
        };
      };
    in
    {
      default = pkgs.callPackage ./nix/devShell.nix args;
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      fuzz = pkgs.callPackage ./nix/devShell.nix (args // { withAfl = true; });
    }
  );

  packages = builtins.foldl' lib.recursiveUpdate { } [
    (forAllPlatforms (pkgs: rec {
      # Deps are needed for environmental setup on macOS
      deps = pkgs.callPackage ./build.zig.zon.nix {
        zig_0_17 = zig_0_17 pkgs.stdenv.hostPlatform.system;
      };

      libghostty-vt-debug = pkgs.callPackage ./nix/libghostty-vt.nix (mkPkgArgs pkgs "debug");
      libghostty-vt-releasesafe = pkgs.callPackage ./nix/libghostty-vt.nix (mkPkgArgs pkgs "safe");
      libghostty-vt-releasefast = pkgs.callPackage ./nix/libghostty-vt.nix (mkPkgArgs pkgs "fast");
      libghostty-vt-debug-no-simd = pkgs.callPackage ./nix/libghostty-vt.nix (
        (mkPkgArgs pkgs "debug") // { simd = false; }
      );
      libghostty-vt-releasesafe-no-simd = pkgs.callPackage ./nix/libghostty-vt.nix (
        (mkPkgArgs pkgs "safe") // { simd = false; }
      );
      libghostty-vt-releasefast-no-simd = pkgs.callPackage ./nix/libghostty-vt.nix (
        (mkPkgArgs pkgs "fast") // { simd = false; }
      );

      libghostty-vt = libghostty-vt-releasefast;
    }))
    (forBuildablePlatforms (pkgs: rec {
      ghostty-debug = pkgs.callPackage ./nix/package.nix (mkPkgArgs pkgs "debug");
      ghostty-releasesafe = pkgs.callPackage ./nix/package.nix (mkPkgArgs pkgs "safe");
      ghostty-releasefast = pkgs.callPackage ./nix/package.nix (mkPkgArgs pkgs "fast");

      ghostty = ghostty-releasefast;
      default = ghostty;
    }))
  ];

  formatter = forAllPlatforms (pkgs: pkgs.alejandra);

  apps = forBuildablePlatforms (
    pkgs:
    let
      runVM =
        module:
        let
          vm = import ./nix/vm/create.nix {
            inherit (pkgs.stdenv.hostPlatform) system;
            inherit module nixpkgs;
            overlay = self.overlays.debug;
          };
          program = pkgs.writeShellScript "run-ghostty-vm" ''
            SHARED_DIR=$(pwd)
            export SHARED_DIR

            ${pkgs.lib.getExe vm.config.system.build.vm} "$@"
          '';
        in
        {
          type = "app";
          program = "${program}";
          meta.description = "start a vm from ${toString module}";
        };
    in
    {
      wayland-cinnamon = runVM ./nix/vm/wayland-cinnamon.nix;
      wayland-gnome = runVM ./nix/vm/wayland-gnome.nix;
      wayland-plasma6 = runVM ./nix/vm/wayland-plasma6.nix;
      x11-cinnamon = runVM ./nix/vm/x11-cinnamon.nix;
      x11-plasma6 = runVM ./nix/vm/x11-plasma6.nix;
      x11-xfce = runVM ./nix/vm/x11-xfce.nix;
    }
  );

  checks = forAllPlatforms (
    pkgs:
    import ./nix/tests.nix {
      inherit home-manager nixpkgs self;
      inherit (pkgs.stdenv.hostPlatform) system;
    }
  );

  overlays = {
    default = self.overlays.releasefast;
    releasefast = final: prev: {
      ghostty = final.callPackage ./nix/package.nix (mkPkgArgs final "fast");
    };
    debug = final: prev: {
      ghostty = final.callPackage ./nix/package.nix (mkPkgArgs final "debug");
    };
  };
}
