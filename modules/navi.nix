{
  flake.homeManagerModules.navi = {
    config,
    lib,
    pkgs,
    utils ? {},
    ...
  }: let
    inherit (lib) concatStringsSep forEach getAttr getExe hm mkDefault mkEnableOption mkIf mkMerge mkOption types;
    inherit (types) coercedTo listOf package str submodule attrsOf int anything;
    inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
    cfg = config.programs.navi;
  in {
    options.programs.navi.autoupdate = {
      enable = mkEnableOption "navi repository autoupdater" // {default = cfg.autoupdate.repositories != [];};
      repositories = mkOption {
        default = [];
        description = "Git repositories to clone regularly for updated cheatsheets";
        type = let
          match = builtins.match ".+/(.+)/(.+)$";
          urlToModule = url: {
            inherit url;
            owner = builtins.elemAt (match url) 0;
            repo = builtins.elemAt (match url) 1;
          };
          strOption = mkOption {type = str;};
          module = submodule {
            options.owner = strOption;
            options.repo = strOption;
            options.url = strOption;
          };
        in listOf (coercedTo str urlToModule module);
      };
      script = mkOption {
        type = package;
        readOnly = true;
        description = "Script to update Navi index with newest repositories";
      };
      timer = let
        # TODO why doesn't this work?
        # darwin.type = options.launchd.agents.options.config.StartCalendarInterval;
        darwin.type = listOf (attrsOf int);
        darwin.default = builtins.genList (i: {Hour = i * 2;}) (24 / 2);
        # TODO how to gracefully hander utils arg for linux on nixos or otherwise
        linux.type = utils.systemdUtils.unitOptions.timerOptions.options.timerConfig or anything;
        args =
          if isDarwin
          then darwin
          else if isLinux
          then linux
          else throw "System ${pkgs.system} not supported!";
      in
        mkOption (args // {description = "service timer for respective system";});
    };
    config = mkIf cfg.enable (mkMerge [
      {
        programs.navi.autoupdate = {
          # TODO how can I determine what these are at eval time? build denisidoro/cheats?
          repositories = map (path: "https://github.com/${path}") [
            "denisidoro/cheats"
            "denisidoro/navi-tldr-pages"
            "denisidoro/dotfiles"
            "mrVanDalo/navi-cheats"
            "chazeon/my-navi-cheats"
            "caojianhua/MyCheat"
            "Kidman1670/cheats"
            "isene/cheats"
            "m42martin/navi-cheats"
            "infosecstreams/cheat.sheets"
            "prx2090/cheatsheets-for-navi"
            "papanito/cheats"
          ];
          script = let
            git' = getExe config.programs.git.package;
            toRepoBashArray = attr: "${attr}s=(${concatStringsSep " " (forEach cfg.autoupdate.repositories (getAttr attr))})";
          in
            pkgs.writeShellScript "navi-autoupdate.sh" ''
              MAX_CONCURRENT_PROCESSES=8
              ${toRepoBashArray "owner"}
              ${toRepoBashArray "repo"}
              ${toRepoBashArray "url"}
              for i in "''${!urls[@]}"; do
                location="$(${getExe cfg.package} info cheats-path)/''${owners[i]}__''${repos[i]}"
                if [[ $1 == clone ]]; then
                  ${git'} clone "''${urls[i]}" "$location" &
                elif [[ $1 == pull ]]; then
                  ${git'} -C "$location" pull --quiet origin &
                fi
                if [[ $(jobs -r -p | wc -l) -ge $MAX_CONCURRENT_PROCESSES ]]; then wait -n; fi
              done
              wait
            '';
          timer = mkIf isLinux {
            Persistent = mkDefault true;
            OnCalendar = mkDefault "*-*-* *:00/2:00";
          };
        };
      }
      (mkIf cfg.autoupdate.enable {
        home.activation.navi = hm.dag.entryAfter ["writeBoundary"] "${cfg.autoupdate.script} clone";
        launchd.agents = mkIf isDarwin {
          navi.enable = true;
          navi.config = {
            KeepAlive.Crashed = true;
            ProgramArguments = [cfg.autoupdate.script "pull"];
            RunAtLoad = true;
            StartCalendarInterval = cfg.autoupdate.timer;
          };
        };
        systemd.user = mkIf isLinux {
          services.navi.Service = {
            Type = "oneshot";
            ExecStart = "${cfg.autoupdate.script} pull";
          };
          timers.navi.Install.WantedBy = ["timers.target"];
          timers.navi.Timer = cfg.autoupdate.timer;
        };
      })
    ]);
  };
}
