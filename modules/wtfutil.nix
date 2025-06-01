{
  flake.homeManagerModules.wtfutil = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.programs) wtf;
    inherit (lib) mkEnableOption mkPackageOption mkOption mkIf;
    yaml = pkgs.formats.yaml {};
  in {
    options.programs.wtf = {
      enable = mkEnableOption "wtfutil";
      package = mkPackageOption pkgs "wtf" {};
      config = mkOption {
        inherit (yaml) type;
        default = {};
        description = "Wtfutil config file";
      };
    };
    config = mkIf wtf.enable {
      home.packages = [wtf.package];
      home.file.".config/wtf/config.yaml".source = yaml.generate "wtfutil.yaml" wtf.config;
    };
  };
}
