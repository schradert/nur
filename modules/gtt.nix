{
  flake.homeManagerModules.gtt = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.programs) gtt;
    inherit (lib) mkEnableOption mkPackageOption mkIf mkOption mkMerge;
    yaml = pkgs.formats.yaml {};
  in {
    options.programs.gtt = {
      enable = mkEnableOption "gtt translation TUI";
      package = mkPackageOption pkgs "gtt" {};
      servers = mkOption {
        inherit (yaml) type;
        description = "Contents of server.yaml";
        default = {};
      };
      keymap = mkOption {
        inherit (yaml) type;
        description = "Contents of keymap.yaml";
        default = {};
      };
      theme = mkOption {
        inherit (yaml) type;
        description = "Contents of theme.yaml";
        default = {};
      };
    };
    config = mkIf gtt.enable {
      home.packages = [gtt.package];
      xdg.configFile = mkMerge [
        (mkIf (gtt.servers != {}) {"gtt/server.yaml".source = yaml.generate "gtt.server.yaml" gtt.servers;})
        (mkIf (gtt.keymap != {}) {"gtt/keymap.yaml".source = yaml.generate "gtt.keymap.yaml" gtt.keymap;})
        (mkIf (gtt.theme != {}) {"gtt/theme.yaml".source = yaml.generate "gtt.theme.yaml" gtt.theme;})
      ];
    };
  };
}