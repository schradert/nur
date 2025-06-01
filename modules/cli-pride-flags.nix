{
  perSystem = {pkgs, ...}: {
    packages.cli-pride-flags = pkgs.callPackage ({
      lib,
      stdenv,
      fetchFromGitHub,
      pnpm_9,
      nodejs,
    }:
      stdenv.mkDerivation (finalAttrs: {
        pname = "cli-pride-flags";
        version = lib.substring 0 7 finalAttrs.src.rev;
        src = fetchFromGitHub {
          owner = "0xf0xx0";
          repo = "cli-pride-flags";
          rev = "c70ab7568074296a282f767bba1590bdb03c4ce0";
          hash = "sha256-vSScnWAI4e/qAqvcVbsmMVtDkN3VJ+XD2pz46J87FVI=";
        };
        nativeBuildInputs = [nodejs pnpm_9.configHook];
        pnpmDeps = pnpm_9.fetchDeps {
          inherit (finalAttrs) pname version src;
          hash = "sha256-pPR6s0EsR36jJRtXZk/4+nnlQTDsES6VAgEz/ZBooiA=";
        };
        meta.mainProgram = "cli-pride-flags";
      })) {};
  };
}
