{
  perSystem = {pkgs, ...}: {packages = {inherit (pkgs) ladybird;};};
  flake.overlays.ladybird = final: prev: {
    ladybird = prev.ladybird.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [final.copyDesktopItems];
      buildInputs = old.buildInputs ++ [final.lcms] ++ final.lib.optional final.stdenv.hostPlatform.isDarwin final.unofficial-angle;
      desktopItems = [
        (final.makeDesktopItem {
          name = "ladybird";
          desktopName = "Ladybird";
          exec = "Ladybird";
          icon = "ladybird";
          comment = old.meta.description;
          categories = ["Network" "InstantMessaging"];
          startupWMClass = "Ladybird";
          terminal = false;
        })
      ];
      postInstall = old.postInstall + "install -D $out/share/Lagom/icons/128x128/app-browser-dark.png $out/share/icons/hicolor/128x128/apps/ladybird.png";
    });
  };
}
