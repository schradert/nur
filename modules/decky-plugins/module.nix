{
  flake.nixosModules.decky = {config, lib, pkgs, ...}: let
    json = pkgs.formats.json {};
  in {
    options.jovian.decky-loader.plugins = let
      inherit (lib) mkOption mkEnableOption mkPackageOption literalExpression types;
      inherit (types) attrsOf submodule;
    in
      mkOption {
        type = attrsOf (submodule ({name, ...}: {
          options.enable = mkEnableOption name;
          options.package = mkPackageOption pkgs ["deckyPlugins" name] {};
          options.settings = mkOption {
            type = submodule {freeformType = json.type;};
            default = {};
            example = literalExpression "{}";
            description = "Unique settings for the ${name} plugin. Accepts valid JSON by default.";
          };
        }));
        default = {};
        example = literalExpression "{css-loader.enable = true;}";
        description = "Plugins with configuration to install alongside decky-loader";
      };
    config = let
      inherit (lib) attrValues concatStringsSep filter flatten forEach getAttr getExe mapAttrs mkIf mkMerge;
      inherit (config.jovian.decky-loader) user stateDir plugins;
      enabledPlugins = filter (getAttr "enable") (attrValues plugins);
      loaderJSON = json.generate "decky-loader.json" {
        branch = 0;
        pluginOrder = [];
        "user_info.user_name" = user;
        "user_info.user_home" = stateDir;
        store = 0;
        "developer.enabled" = false;
      };
      loaderPath = "${stateDir}/settings/loader.json";
      jq = getExe pkgs.jq;
      installPlugins = ''
        rm -rf ${stateDir}/{plugins,settings}
        mkdir -p ${stateDir}/{plugins,settings}
        chown -R ${user}: ${stateDir}
        cp ${loaderJSON} ${loaderPath}
        ${concatStringsSep "\n" (forEach enabledPlugins (plugin: let
          inherit (plugin.package) pname;
          settingsJSON = json.generate "${pname}-settings.json" plugin.settings;
          queryPluginName = "${jq} --raw-output '.name' ${stateDir}/plugins/${pname}/plugin.json";
        in ''
          mkdir -p ${stateDir}/{plugins,settings}/${pname}
          cp -R ${plugin.package}/* ${stateDir}/plugins/${pname}
          cp ${settingsJSON} ${stateDir}/settings/${pname}/config.json
          ${jq} --arg plugin "$(${queryPluginName})" '.pluginOrder += [$plugin]' ${loaderPath} \
              | ${pkgs.moreutils}/bin/sponge ${loaderPath}
        ''))}
      '';
    in
      mkMerge [
        {jovian.decky-loader.plugins = mapAttrs (_: _: {}) pkgs.deckyPlugins;}
        (mkIf (config.jovian.decky-loader.enable or false) {
          jovian.decky-loader.extraPythonPackages = ps: flatten (forEach enabledPlugins (plugin: plugin.package.extraPythonPackages ps));
          jovian.decky-loader.extraPackages = flatten (forEach enabledPlugins (plugin: plugin.package.extraPackages));
          systemd.services.decky-loader.preStart = installPlugins;
        })
      ];
  };
}
