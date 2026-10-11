{
  imports = [./module.nix ./plugins.nix];
  perSystem = {pkgs, ...}: {legacyPackages = {inherit (pkgs) buildDeckyPlugin;};};
  flake.overlays.decky = final: _: {
    # `pnpm` picks the pnpm matching the plugin's lockfile (pnpm_8 reads v6, pnpm_9 v9)
    buildDeckyPlugin = {pnpm ? final.pnpm_8, ...} @ attrs: final.callPackage ({
      lib,
      fetchPnpmDeps,
      pnpmConfigHook,
      stdenv,
      nodejs,
    }: stdenv.mkDerivation (finalAttrs: lib.recursiveUpdate {
      pnpmDeps = fetchPnpmDeps {
        inherit (finalAttrs) pname src version;
        inherit pnpm;
        fetcherVersion = 3;
        hash = finalAttrs.pnpmLockHash;
      };
      nativeBuildInputs = [nodejs pnpm pnpmConfigHook];
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
    } (removeAttrs attrs ["pnpm"]))) {};
  };
}
