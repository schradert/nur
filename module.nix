{
  flake-parts-lib,
  inputs,
  lib,
  moduleLocation,
  self,
  ...
}: let
  inherit (lib) mapAttrs mkForce mkMerge mkOption types;
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
    homeManagerModules = defineClassModules "homeManagerModules" "home-manager";
    nixosModules = defineClassModules "nixosModules" "nixos";
  };
  config.systems = import inputs.systems;
  config.perSystem = {
    config,
    pkgs,
    self',
    ...
  }: {
    # NOTE need mergeable attrset for colocation since attributes of legacyPackages are not
    options.lib = mkOption {
      default = {};
      type = lazyAttrsOf raw;
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
