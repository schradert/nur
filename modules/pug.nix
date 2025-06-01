{
  flake.overlays.pug = final: _: {
    pug = final.callPackage ({
      lib,
      buildGoModule,
      fetchFromGitHub,
    }:
      buildGoModule rec {
        pname = "pug";
        version = lib.substring 0 7 src.rev;
        src = fetchFromGitHub {
          owner = "leg100";
          repo = "pug";
          rev = "37d0e02dd44092ad584977a0e54cc991551b3cb6";
          hash = "sha256-XQkQ9K3gB9wSgQ+Bt7Vl0xnA5mZCHiGLVx/gXuB9HNM=";
        };
        vendorHash = "sha256-jsZ7noyAhKvOVpcYwCY3DmRvAUOPUczeokat4u6n13A=";
        checkFlags = let
          skippedTests = [
            # Requires network access
            "TestTask_cancel"
            # TODO why does this have to be skipped? ERROR: fork/exec ./testdata/task: no such file or directory
            "TestTask_NewReader"
          ];
        in ["-skip=^${lib.concatStringsSep "$|^" skippedTests}$"];
        postInstall = "wrapProgram $out/bin/pug --set PUG_CONFIG=\"\\\${XDG_CONFIG_HOME:\$HOME/.config}/pug/config.yaml\"";
        meta = {
          mainProgram = "pug";
          homepage = "https://github.com/leg100/pug";
          changelog = "${meta.homepage}/blob/${src.rev}/CHANGELOG.md";
          description = "Drive terraform at terminal velocity.";
          license = lib.licenses.mpl20;
        };
      }) {};
  };
  flake.homeManagerModules.pug = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkEnableOption mkPackageOption mkOption mkIf types;
    cfg = config.programs.pug;
    yaml = pkgs.formats.yaml {};
  in {
    options.programs.pug = {
      enable = mkEnableOption "pug";
      package = mkPackageOption pkgs "pug" {};
      settings = mkOption {
        inherit (yaml) type;
        default = {};
        description = "Structured contents of config.yaml";
      };
    };
    config = mkIf cfg.enable {
      home.packages = [cfg.package];
      xdg.configFile = mkIf (cfg.settings != {}) {"pug/config.yaml".source = yaml.generate "pub.config.yaml" cfg.settings;};
    };
  };
}
