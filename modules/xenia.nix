{
  perSystem = {pkgs, ...}: {packages = {inherit (pkgs) xenia-canary;};};
  flake.overlays.xenia = final: _: {
    # TODO fix xenia build
    # NOTE https://github.com/NixOS/nixpkgs/issues/108212
    # NOTE https://github.com/xenia-project/xenia
    xenia-canary = final.callPackage ({
      clangStdenv,
      fetchFromGitHub,
      lib,
      python3,
      pkg-config,
      gtk3,
      SDL2,
      # lz4,
      # libunwind,
      # libiberty,
      # xorg,
      # vulkan-loader
    }:
      clangStdenv.mkDerivation rec {
        pname = "xenia-canary";
        version = lib.substring 0 7 src.rev;
        src = fetchFromGitHub {
          owner = "xenia-canary";
          repo = "xenia-canary";
          rev = "764f230dd9883bfb63e3aea7642aac26f010e1bb";
          hash = "sha256-sMankinz4vYnmuKyUgETOgOgaW8ezQc3galGP1mLw24=";
          fetchSubmodules = true;
        };
        nativeBuildInputs = [
          python3
          pkg-config
        ];
        buildInputs = [
          gtk3
          SDL2
          #   lz4
          #   libunwind
          #   libiberty
          #   xorg.libX11
          #   xorg.libxcb
        ];
        # dontConfigure = true;
        NIX_CFLAGS_COMPILE = [
          "-Wno-error=implicit-function-declaration"
          #   "-Wno-error=unused-result"
          #   "-fno-lto"
        ];
        buildPhase = ''
          runHook preBuild
          python3 ./xb setup
          python3 ./xb build --config release -j $NIX_BUILD_CORES
          runHook postBuild
        '';
        # installPhase = ''
        #   runHook preInstall
        #   mkdir -p $out/bin
        #   cp -a ./build/bin/*/*/xenia $out/bin/
        #   runHook postInstall
        # '';
        # postFixup = "patchelf --add-rpath ${vulkan-loader}/lib $out/bin/xenia";
      }) {};
  };
}
