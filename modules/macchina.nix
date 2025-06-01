{
  flake.homeManagerModules.macchina = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkEnableOption mkPackageOption mkOption mkIf mkMerge nameValuePair attrNames flip filterAttrsRecursive mapAttrs' substring types;
    inherit (pkgs) stdenv formats fetchFromGitHub fetchurl runCommand;
    inherit (types) submodule nullOr str enum attrsOf coercedTo package;
    cfg = config.programs.macchina;
    toml = formats.toml {};
    settingsNotNull = filterAttrsRecursive (_: v: v != null) cfg.settings;
  in {
    options.programs.macchina = {
      enable = mkEnableOption "macchina";
      package = mkPackageOption pkgs "macchina" {};
      settings = mkOption {
        default = {};
        description = "Contents of Macchina settings";
        type = submodule {
          freeformType = toml.type;
          options.interface = mkOption {
            type = nullOr str;
            default = null;
            example = "wlan0";
            description = "Network interface to display a local IP for";
          };
          options.theme = mkOption {
            type = nullOr (enum (attrNames cfg.themes));
            default = null;
            description = "Theme to activate";
          };
        };
      };
      themes = mkOption {
        type = attrsOf (coercedTo toml.type (toml.generate "macchina-theme.toml") package);
        default = {};
        description = "Contents or files for different Macchina themes";
      };
    };
    config = mkIf cfg.enable {
      home.packages = [cfg.package];
      xdg.configFile = mkMerge [
        (mkIf (settingsNotNull != {}) {"macchina/macchina.toml".source = toml.generate "macchina.toml" settingsNotNull;})
        (flip mapAttrs' cfg.themes (name: file: nameValuePair "macchina/themes/${name}.toml" {
          source = runCommand "${name}.toml" {
            # Patch with NixOS ASCII
            customAsciiPath = fetchurl {
              url = "https://gist.githubusercontent.com/manpages/d68f2497cafb41b0c3d7/raw/fe1b5b77d48e7ff4443e96afff72bbe0c31dc5ee/Nix-logo.render";
              hash = "sha256-OfuhzjYtAaLrAztK3px/WRs1wlYY563ioJQRShmnTHY=";
            };
          } ''
            ${pkgs.yq}/bin/tomlq --toml-output '.custom_ascii.path |= "$customAsciiPath"' ${file} > $out
          '';
        }))
      ];

      programs.macchina.themes.Dracula = stdenv.mkDerivation rec {
        name = "macchina-dracula";
        version = substring 0 7 src.rev;
        src = fetchFromGitHub {
          owner = "di-effe";
          repo = "macchina-cli-themes";
          rev = "c1d7087b6999b36671d70ce2abf581ef1a9223d8";
          hash = "sha256-hlDafPLy15Tury345lYnW1sKBtLmxaahhsCJyL6SYcg=";
        };
        installPhase = "cp Dracula.toml $out";
      };
    };
  };
}
