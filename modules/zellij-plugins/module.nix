{self, ...}: {
  flake.homeManagerModules.zellij-plugins = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config.programs) zellij;
    inherit (lib) hm listToAttrs mapAttrs mkIf mkOption nameValuePair pipe;
  in {
    options.programs.zellij.plugins = mkOption {
      default = _: [];
      description = "Plugins to include in zellij configuration";
      type = hm.types.selectorFunction;
    };
    config = mkIf zellij.enable {
      programs.zellij.settings.plugins = pipe pkgs.zellijPlugins [
        zellij.plugins
        (map (package: nameValuePair package.pname package))
        listToAttrs
        (mapAttrs (name: plugin: {location = "file:${plugin}/bin/${plugin.filename or name}.wasm";}))
      ];
    };
  };
}
