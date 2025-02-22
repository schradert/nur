{lib, withSystem, ...}: {
  flake.overlays.zellij-plugins = final: _: {
    zellijPlugins = withSystem final.stdenv.hostPlatform.system ({self', ...}: lib.genAttrs ["harpoon" "room" "jbz" "monocle" "multitask" "forgot"] (lib.flip lib.getAttr self'));
  };
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages = builtins.mapAttrs (_: self'.legacyPackages.buildZellijPlugin) {
      harpoon.cargoHash = "sha256-5b3lvxobzNbu4i4dyMGPnXfiWCENaqX7t8lfSgHQ3Rs=";
      harpoon.src = pkgs.fetchFromGitHub {
        owner = "Nacho114";
        repo = "harpoon";
        rev = "d3284615ba5063c73e0c1729edf5b10b46aead5e";
        hash = "sha256-heQ81oZjREU2jMmVG02KJQ6DwnCa7zT1umb5kNENxWY=";
      };
      room.src = pkgs.fetchFromGitHub {
        owner = "rvcas";
        repo = "room";
        rev = "fd6dc54a46fb9bce21065ce816189c037aeaf24f";
        hash = "sha256-T1JNFJUDCtCjXtZQUe1OQsfL3/BI7FUw60dImlUmLhg=";
      };
      jbz.src = pkgs.fetchFromGitHub {
        owner = "nim65s";
        repo = "jbz";
        rev = "e547d0386b07390587290273f633f1fdf90303c4";
        hash = "sha256-vDCRR/sFwCF6/ZYaZIVh9dnGNd4hh/f1JjDEPwQTxgU=";
      };
      monocle.src = pkgs.fetchFromGitHub {
        owner = "imsnif";
        repo = "monocle";
        rev = "ec980abab220a1ec0a4434b283ea160838219321";
        hash = "sha256-LZQn4aXroYPpn6pMydo3R4mEcZpUm2m6CDSY4azrJlw=";
      };
      multitask.src = pkgs.fetchFromGitHub {
        owner = "imsnif";
        repo = "multitask";
        rev = "62369617b2aa1ac30c822361fb820dfa13ae4c70";
        hash = "sha256-qldgUK4yEDx7i8TH3dGIBBzaIJCNCaeEduP+NiLPSt8=";
      };
      zellij-forgot.src = pkgs.fetchFromGitHub {
        owner = "karimould";
        repo = "zellij-forgot";
        rev = "3cc723b5741e8a26fe3c8f50756705e8c68d223b";
        hash = "sha256-fftXugdUy/UQ3lKwsugL0xjbDCjppRekUXFbtZ10gE0=";
      };
    };
  };
}
