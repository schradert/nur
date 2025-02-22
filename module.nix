{
  flake-parts-lib,
  inputs,
  lib,
  moduleLocation,
  self,
  ...
}: let
  inherit (lib) mapAttrs mkMerge mkOption types;
  inherit (types) deferredModule lazyAttrsOf raw;
  defineClassModules = key: class:
    mkOption {
      default = {};
      type = lazyAttrsOf deferredModule;
      apply = mapAttrs (name: module: {
        _class = class;
        _file = "${toString moduleLocation}#${key}.${name}";
        imports = [module];
      });
    };
in {
  # NOTE flake-parts definition of nixosModules exists but excludes _class
  disabledModules = ["${inputs.flake-parts}/modules/nixosModules.nix"];
  imports = [./modules];
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    commonModules = defineClassModules "commonModules" null;
    homeManagerModules = defineClassModules "homeManagerModules" "homeManager";
    nixosModules = defineClassModules "nixosModules" "nixos";
  };
  config.systems = import inputs.systems;
  config.perSystem = {
    config,
    pkgs,
    self',
    system,
    ...
  }: {
    # NOTE need mergeable attrset for colocation since attributes of legacyPackages are not
    options.lib = mkOption {
      default = {};
      type = lazyAttrsOf raw;
    };
    config._module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      # Android projects need this by default
      config.allowUnfree = true;
      config.android_sdk.accept_license = true;
    };
    config.formatter = pkgs.alejandra;
    config.legacyPackages = mkMerge [
      self'.packages
      {
        inherit (config) lib;
        inherit (self) overlays;
        modules = mkMerge [self.commonModules self.homeManagerModules self.nixosModules];
      }
    ];
  };
}
