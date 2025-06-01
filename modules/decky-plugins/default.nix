{
  imports = [./module.nix ./plugins.nix];
  perSystem = {pkgs, ...}: {legacyPackages = {inherit (pkgs) buildDeckyPlugin;};};
  flake.overlays.decky = final: _: {
    buildDeckyPlugin = attrs: final.callPackage ({
      lib,
      # NOTE pnpm pinned to version 8 because pnpm.fetchDeps is unstable to changes in pnpm registry tools, which broke "recently"
      pnpm_8,
      stdenv,
      nodejs,
    }: stdenv.mkDerivation (finalAttrs: lib.recursiveUpdate {
      pnpmDeps = pnpm_8.fetchDeps {
        inherit (finalAttrs) pname src version;
        hash = finalAttrs.pnpmLockHash;
      };
      nativeBuildInputs = [nodejs pnpm_8.configHook];
      buildPhase = "pnpm build";
      # Ignore zero glob matches
      installPhase = ''
        runHook preInstall

        mkdir -p $out/dist
        shopt -s nullglob
        cp -R ./dist *.py *.json LICENSE* README* $out || true

        runHook postInstall
      '';
      # TODO build dependencies into each plugin
      passthru.extraPackages = [];
      passthru.extraPythonPackages = _: [];
    } attrs)) {};
  };
}