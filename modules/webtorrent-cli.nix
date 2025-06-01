{
  perSystem = {pkgs, ...}: {packages = {inherit (pkgs) webtorrent-cli;};};
  flake.overlays.webtorrent-cli = final: _: {
    # TODO figure out what is breaking this! https://discourse.nixos.org/t/buildnpmpackage-enotcached/58832
    webtorrent-cli = pkgs.callPackage ({
      lib,
      buildNpmPackage,
      fetchFromGitHub,
      importNpmLock,
    }:
      buildNpmPackage rec {
        pname = "webtorrent-cli";
        version = "5.1.3";
        src = fetchFromGitHub {
          owner = "webtorrent";
          repo = "webtorrent-cli";
          rev = "refs/tags/v${version}";
          hash = "sha256-hSQ3j5t/k50/D2ZGO1Whh3bgZNIVmPYUrBsd9V1YQZc=";
        };
        npmDeps = importNpmLock {
          npmRoot = src;
          packageLock = lib.importJSON ./package-lock.json;
        };
        inherit (importNpmLock) npmConfigHook;
        meta = {
          description = "WebTorrent, the streaming torrent client. For the command line.";
          homepage = "https://github.com/webtorrent/webtorrent-cli";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [schradert];
          platforms = lib.platforms.all;
        };
      }) {};
  };
}
