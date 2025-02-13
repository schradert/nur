{
  flake.homeManagerModules.zellij-plugins = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.programs) zellij;
    inherit (lib) hm mapAttrs mkIf mkOption replaceStrings;
    mapPluginPath = name: plugin: {path = "${plugin}/bin/${replaceStrings ["-"] ["_"] name}.wasm";};
  in {
    options.programs.zellij.plugins = mkOption {
      default = _: [];
      description = "Plugins to include in zellij configuration";
      type = hm.types.selectorFunction;
    };
    config = mkIf zellij.enable {
      programs.zellij.settings.plugins = mapAttrs mapPluginPath (zellij.plugins pkgs);
    };
  };
}
