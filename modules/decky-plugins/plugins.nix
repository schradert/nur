{
  perSystem = {lib, pkgs, ...}: {
    packages = lib.filterAttrs (_: lib.isDerivation) pkgs.deckyPlugins;
  };
  flake.overlays.decky-plugins = final: _: {
    deckyPlugins = final.callPackage ({
      lib,
      newScope,
      buildDeckyPlugin,
      fetchFromGitHub,

      pulseaudio,
    }: lib.makeScope newScope (dpkgs: let
      gitRev = src: lib.substring 0 7 src.rev;
    in {
      css-loader = buildDeckyPlugin rec {
        pname = "SDH-CssLoader";
        version = "2.1.2";
        src = fetchFromGitHub {
          owner = "DeckThemes";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-dEhK1LcOMerSQsOiUahMm/RX78ABNsKReQfRfspyw68=";
        };
        pnpmLockHash = "sha256-cvYXpHeVSzyZCoNLrNyLGZQN2PVrptmgaZJmMTOfink=";
        passthru.extraPythonPackages = ps: with ps; [aiohttp aiohttp-jinja2 aiohttp_cors watchdog certifi pystray];
      };
      vibrant-deck = buildDeckyPlugin rec {
        pname = "vibrantDeck";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "libvibrant";
          repo = pname;
          rev = "b0043b9a4660f5029b0c17d73e06b5e34eaddd40";
          hash = "sha256-Jfq3sJLmzp4943l5dkJpU/tyecDAfwfyDH6jxuRiSUA=";
        };
        pnpmLockHash = "sha256-g0ReI6U0/3zh+WDPgd6hFOm7gncFTBbBWfQNPN74chg=";
      };
      animation-changer = buildDeckyPlugin rec {
        pname = "SDH-AnimationChanger";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "TheLogicMaster";
          repo = pname;
          rev = "eacfbfa7c82153791d03986e5ad6ef04c308b2c9";
          hash = "sha256-7h3cbF533BRWuyCfg/aNSCdxeC5EmwP9VDyr/iARUO4=";
        };
        pnpmLockHash = "sha256-NYp5zDCRL6C5uLtBIgoJUevLX1kXw2zE8ogjV2EwK0w=";
        passthru.extraPythonPackages = ps: with ps; [aiohttp certifi];
      };
      hltb = buildDeckyPlugin rec {
        pname = "hltb-for-deck";
        version = "2.0.0";
        src = fetchFromGitHub {
          owner = "SDH-Stewardship";
          repo = pname;
          rev = "c18f2c5f550fb65b8e655e3489ab1228c0c9fd4c";
          hash = "sha256-L9LEPF1hoSk4hMRJr6EqII3C48zLhtDfdokdsKROZRw=";
        };
        pnpmLockHash = "sha256-tukcBwfix35ygmOjt+F6aVc+pAPrPtR08HVpNDcMrIg=";
      };
      bluetooth = buildDeckyPlugin rec {
        pname = "Bluetooth";
        version = "2.3.0";
        src = fetchFromGitHub {
          owner = "Outpox";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-RMcEgjiKgmjCI9cj8dVfedx4LaGMPAk48R62hbWZHew=";
        };
        pnpmLockHash = "sha256-nCuUvMaAg3cp8iAF7JSsKYM3y1FtxbSBxlLlCn6TMF0=";
      };
      volume-boost = buildDeckyPlugin rec {
        pname = "volume-boost";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "saumya-banthia";
          repo = pname;
          rev = "08c28f309f06ef7a7f1faa18bc617529d20d4cf3";
          hash = "sha256-kIdIzYTUag/FfNe1jqe9Bkj0OggFOvk2HcH4sq1i9p4=";
        };
        pnpmLockHash = "sha256-/e8pMzYgxb1ZhNON+J5gQh+E1fiEpm7o5DQ+GKBb8B4=";
        extraPackages = [pulseaudio];
      };
      steamgriddb = buildDeckyPlugin rec {
        pname = "decky-steamgriddb";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "SteamGridDB";
          repo = pname;
          rev = "f9891ee15b55a1b22fad3060131b62bae9a18558";
          hash = "sha256-ZDyGcggoHzQglaKDu5WZ7oKC9BOw6FyHrZv0dWYXJZY=";
        };
        pnpmLockHash = "sha256-/DKBXv6cyDotwiPeL5MAXLYYoqUZZwe70lfm7ywGzDk=";
      };
      protondb = buildDeckyPlugin rec {
        pname = "protondb-decky";
        version = "1.1.0";
        src = fetchFromGitHub {
          owner = "OMGDuke";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-FFoyvCeNi0Xb1F3l5At3G5ikC8PykwMnOVeAOtN3FQc=";
        };
        pnpmLockHash = "sha256-ECULNUySBvhUhXX/qbL0wJ7v5uapJnmv/Z4Ad3os9p4=";
      };
      recorder = buildDeckyPlugin rec {
        pname = "decky-recorder";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "safijari";
          repo = "decky-recorder-fork";
          rev = "aa91a45dfa388fa892f8d08513dd769e372aec06";
          hash = "sha256-u4CfKEepd9D6vIUGBlCT1ZVsAfXb/jeNLBDQ09VZfwg=";
        };
        pnpmLockHash = "sha256-Q6k6lHZH2N3HRa1JH2WhtZHdWFHek0dyeI/ZAhLDMHI=";
      };
      mango-peel = buildDeckyPlugin rec {
        pname = "MangoPeel";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "Gawah";
          repo = pname;
          rev = "d609044edd4e8bfb4180a14edbcdbb82f9b1de3b";
          hash = "sha256-Gz3lIoSAUWEuuI776pZc0hzgCuaa/1aa20WesUWxK08=";
        };
        pnpmLockHash = "sha256-Ngg1LMkB8wbZyzb+5JhsL6TRhZRLxuYAK+KPH9Q+E4w=";
      };
      game-theme-music = buildDeckyPlugin rec {
        pname = "SDH-GameThemeMusic";
        version = "1.6.0";
        src = fetchFromGitHub {
          owner = "OMGDuke";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-zgQ+mLsLS+077CSIze6qJZThNaKzRaUPQ4dim1G3mZ4=";
        };
        pnpmLockHash = "sha256-fu6VVKqcSSAJ+0WCpCHjopDw6KY8beAcL3KAZAGZ72c=";
      };
      storage-cleaner = buildDeckyPlugin rec {
        pname = "decky-storage-cleaner";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "mcarlucci";
          repo = pname;
          rev = "bea1b73aaffc78c3f7adf4ea051f7d464c7b1a71";
          hash = "sha256-agiDoGfxe08NoS2TY/3JtwliQC4budphU5tMNysIECc=";
        };
        pnpmLockHash = "sha256-oIskp8JQFDrIGUQE/mq5/PlmLJSxYooMvaejR6MNVV0=";
      };
      music-control = buildDeckyPlugin rec {
        pname = "MusicControl";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "mirobouma";
          repo = pname;
          rev = "2ba3930b1c0644258306bad3bbd3f8a88dfb3610";
          hash = "sha256-rEA5Vyl/Q06eqZAF3+nzio0szlVV3sqeGlCQZK5po4E=";
        };
        pnpmLockHash = "sha256-UkuIccFGFx9tM3M95Y03svCSuqXlZaXKfx7t51WMszw=";
      };
      quick-launch = buildDeckyPlugin rec {
        pname = "SDH-QuickLaunch";
        version = "1.2.0";
        src = fetchFromGitHub {
          owner = "Fisch03";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-6x/angvXEZSZr0OWqmZXws1i8a0zxu/jDvNLWJv/z3I=";
        };
        pnpmLockHash = "sha256-Cedo4iAYlGQgEmERviQEKskrhbCY44ooQq76ewWh0mk=";
      };
      roulette = buildDeckyPlugin rec {
        pname = "decky-roulette";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "davocarli";
          repo = pname;
          rev = "35e17cdadec1f9f4e6a3d750848398ae8eacb626";
          hash = "sha256-/Q1UZyVPh/oyIu1Z3RiAEgNwuN/deZQfOnwFlnXp5sM=";
        };
        pnpmLockHash = "sha256-gPW53hE5OV4r2nqCVtju76M/5zl+LkPC25CoTz/Po0o=";
      };
      audio-loader = buildDeckyPlugin rec {
        pname = "SDH-AudioLoader";
        version = "1.6.0";
        src = fetchFromGitHub {
          owner = "DeckThemes";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-2BRnNLD5ILhUnQrU9jjhz8CBcV3eqhy7RaqyzrlQbhY=";
        };
        pnpmLockHash = "sha256-SjNABg213Bs1l54wW0sIeE6ENiNGNnh8VMXV8Vlnlbo=";
      };
      autosuspend = buildDeckyPlugin rec {
        pname = "decky-autosuspend";
        version = "2.1.0";
        src = fetchFromGitHub {
          owner = "jurassicplayer";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-SQUd66RsLwXQj3je/jg/G8tG0mRKYRocFLFGGch1TFs=";
        };
        pnpmLockHash = "sha256-TySqd5zJD1wJR9SdpH3vatQ7QZtMRsQVX0f937HpCDk=";
      };
      shotty = buildDeckyPlugin rec {
        pname = "Shotty";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "safijari";
          repo = pname;
          rev = "333e22764fa0a6324796b5be5cee8f7412461dfd";
          hash = "sha256-RqlUNeCh6z8kamEBmJms1efixXOxWdjWtOBX5x+mu5k=";
        };
        pnpmLockHash = "sha256-4XKoQtar1fBQL+RJjLqqMUK/SpxpT9FgYX68SIB6QZw=";
      };
      meta-deck = buildDeckyPlugin rec {
        pname = "MetaDeck";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "EmuDeck";
          repo = pname;
          rev = "49be099a5c570d61b1d4753ad45c91c249bca79f";
          hash = "sha256-CY/2T/gT9jacUB49ks5rv5zOsAf4nRJ8EL8YAMTgqQU=";
        };
        pnpmLockHash = "sha256-I0tyfpgbAuT2f2V9ybp1Fe6/998aekl+quhUPnrZaSE=";
      };
      is-there-any-deal = buildDeckyPlugin rec {
        pname = "IsThereAnyDeal-DeckyPlugin";
        version = "1.0.1";
        src = fetchFromGitHub {
          owner = "JtdeGraaf";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-37oXX/eHnZBFrwg3JcIehkDaTLl5G1jpKuAQO7njQQ0=";
        };
        pnpmLockHash = "sha256-A3CNb6vrm3LL1HRpZ0ufzINkSjqCAPRdAeWaDqQN/+g=";
      };
      # TODO this plugin has so many hardcoded paths and dependency on flatpak
      junk-store = buildDeckyPlugin rec {
        pname = "Junk-Store";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "ebenbruyns";
          repo = "junkstore";
          rev = "9cddc6630cde8fb890d5364147a3211535c5b9bd";
          hash = "sha256-njKRIJRv7pqW3l4Rgu6Bf8ByTHW1h+qh6v2Qb+4lz28=";
        };
        pnpmLockHash = "sha256-eEQ8irOcVBzuNms8X93ehpyzlcX4Jvnh3MYvQ7tuu+g=";
        postInstall = ''
          mkdir -p $out/defaults
          cp -R ./defaults scripts conf_schemas $out
        '';
      };
      # TODO figure out backend rust library
      controller-tools = buildDeckyPlugin rec {
        pname = "decky-controller-tools";
        version = "2.0.0";
        src = fetchFromGitHub {
          owner = "jfernandez";
          repo = "ControllerTools";
          rev = "v${version}";
          hash = "sha256-Fd/d90Rgp2uiHrjbL55HNjJ894bY30qiRPQkqlbjCuM=";
        };
        pnpmLockHash = "sha256-uAEQvT5MkPYS/WFniEXXdlM2bwB27jVDKlhUDAU0g9U=";
      };
      # TODO why does this fail with pnpm-lock.yaml not found?!
      SDH-FreeGames = buildDeckyPlugin rec {
        pname = "SDH-FreeGames";
        version = gitRev src;
        src = fetchFromGitHub {
          owner = "WerWolv";
          repo = "SDH-FreeGames";
          rev = "69a0201d40d1cc6a4e25559c66f31d30cd2c2575";
          hash = "sha256-sIf6gLxL8jmZOZ0ICwQZGc6fVv0WQAzUnVBhjJCvj1s=";
        };
        pnpmLockHash = "";
      };
      # TODO build successfully
      SDH-PauseGames = buildDeckyPlugin rec {
        pname = "SDH-PauseGames";
        version = "0.4.2";
        src = fetchFromGitHub {
          owner = "popsUlfr";
          repo = "SDH-PauseGames";
          rev = "v${version}";
          hash = "sha256-0DRzInUEkSD3S3+cBhI5dcohyDthRUUKZBn46u3lHao=";
        };
        pnpmLockHash = "";
      };      
    })) {};
  };
}
