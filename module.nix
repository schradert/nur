{
  flake-parts-lib,
  inputs,
  lib,
  moduleLocation,
  self,
  ...
}: let
  inherit (inputs) flake-parts systems nixpkgs fenix;
  inherit (lib) attrValues mapAttrs mkMerge mkOption types;
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
  disabledModules = ["${flake-parts}/modules/nixosModules.nix"];
  imports = [./modules];
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    commonModules = defineClassModules "commonModules" null;
    homeManagerModules = defineClassModules "homeManagerModules" "homeManager";
    nixosModules = defineClassModules "nixosModules" "nixos";
  };
  config.systems = import systems;
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
    config._module.args.pkgs = import nixpkgs {
      inherit system;
      overlays = attrValues self.overlays ++ [fenix.overlays.default];
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
