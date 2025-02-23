{
  imports = [./module.nix ./plugins.nix];
  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    # NOTE this bespoke solution may not be as robust as the one in zjstatus using crane and rust-overlay
    # LINK https://github.com/dj95/zjstatus/blob/main/flake.nix
    legacyPackages.buildZellijPlugin = args @ {src, ...}:
      pkgs.callPackage (
        {
          lib,
          lld,
          rustPlatform,
        }: let
          inherit ((lib.importTOML (src + "/Cargo.toml")).package) name version;
          lockFile = src + "/Cargo.lock";
          defaultArgs = {
            inherit version src;
            pname = name;
            cargoLock =
              if builtins.pathExists lockFile
              then {inherit lockFile;}
              else null;
            depsBuildBuild = [lld];
            env.RUSTFLAGS = "-C linker=wasm-ld";
          };
          overrideArgs = removeAttrs args ["src"];
        in
          rustPlatform.buildRustPackage (lib.recursiveUpdate defaultArgs overrideArgs)
      ) {
        rustPlatform = let
          # TODO track zellij-utils dependencies for an update to migrate to nightly
          # NOTE zellij-utils indirectly requires ahash ^0.7.0 which has a bug with nightly rust
          # LINK https://github.com/tkaitchuck/aHash/issues/200
          toolchain = with inputs'.fenix.packages;
            combine [
              stable.rustc
              stable.cargo
              targets.wasm32-wasip1.stable.rust-std
            ];
        in
          pkgs.pkgsCross.wasi32.makeRustPlatform {
            rustc = toolchain;
            cargo = toolchain;
          };
      };
  };
}
