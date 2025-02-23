{
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages = builtins.mapAttrs (_: self'.legacyPackages.buildZellijPlugin) {
      harpoon.cargoHash = "sha256-5b3lvxobzNbu4i4dyMGPnXfiWCENaqX7t8lfSgHQ3Rs=";
      harpoon.src = pkgs.fetchFromGitHub {
        owner = "Nacho114";
        repo = "harpoon";
        rev = "d3284615ba5063c73e0c1729edf5b10b46aead5e";
        hash = "sha256-heQ81oZjREU2jMmVG02KJQ6DwnCa7zT1umb5kNENxWY=";
      };
      room.src = pkgs.fetchFromGitHub {
        owner = "rvcas";
        repo = "room";
        rev = "fd6dc54a46fb9bce21065ce816189c037aeaf24f";
        hash = "sha256-T1JNFJUDCtCjXtZQUe1OQsfL3/BI7FUw60dImlUmLhg=";
      };
      jbz.src = pkgs.fetchFromGitHub {
        owner = "nim65s";
        repo = "jbz";
        rev = "e547d0386b07390587290273f633f1fdf90303c4";
        hash = "sha256-vDCRR/sFwCF6/ZYaZIVh9dnGNd4hh/f1JjDEPwQTxgU=";
      };
      monocle.src = pkgs.fetchFromGitHub {
        owner = "imsnif";
        repo = "monocle";
        rev = "ec980abab220a1ec0a4434b283ea160838219321";
        hash = "sha256-LZQn4aXroYPpn6pMydo3R4mEcZpUm2m6CDSY4azrJlw=";
      };
      multitask.src = pkgs.fetchFromGitHub {
        owner = "imsnif";
        repo = "multitask";
        rev = "62369617b2aa1ac30c822361fb820dfa13ae4c70";
        hash = "sha256-qldgUK4yEDx7i8TH3dGIBBzaIJCNCaeEduP+NiLPSt8=";
      };
      zellij-forgot.src = pkgs.fetchFromGitHub {
        owner = "karimould";
        repo = "zellij-forgot";
        rev = "3cc723b5741e8a26fe3c8f50756705e8c68d223b";
        hash = "sha256-fftXugdUy/UQ3lKwsugL0xjbDCjppRekUXFbtZ10gE0=";
      };
      zjswitcher.src = pkgs.fetchFromGitHub {
        owner = "WingsZeng";
        repo = "zjswitcher";
        rev = "v0.2.1";
        hash = "sha256-lACbFz3GP4E2kArdjTjpLdd1GpG9s7fo6mR0ltVO9Og=";
      };
      zpane.src = pkgs.fetchFromGitHub {
        owner = "FuriouZz";
        repo = "zjpane";
        rev = "v0.2.0";
        hash = "sha256-PnlXqyCWf9iK+jutnOkn0ZbvqVFrH0kBjc4IqL1J1Io=";
      };
      zj-quit.src = pkgs.fetchFromGitHub {
        owner = "cristiand391";
        repo = "zj-quit";
        rev = "0.3.1";
        hash = "sha256-APimuHdhfxIBGIzCkT42+wSQCDv5Do5OKtmr997Usfs=";
      };
      zj-status-bar.src = pkgs.fetchFromGitHub {
        owner = "cristiand391";
        repo = "zj-status-bar";
        rev = "0.3.0";
        hash = "sha256-mIXoCep3L/A9hPSPClINUxjTaVAT+N65pQP3V+Wl4gc=";
      };
      zj-docker.src = pkgs.fetchFromGitHub {
        owner = "dj95";
        repo = "zj-docker";
        rev = "v0.4.0";
        hash = "sha256-xuypRhYDXAvYgvCusxa+ut8ITIuZxYkUa3fdu1eLSdA=";
      };
      zellij-workspace.src = pkgs.fetchFromGitHub {
        owner = "vdbulcke";
        repo = "zellij-workspace";
        rev = "v0.2.0";
        hash = "sha256-7KYdYCzCOq5nqjpzYESJCQi4UB+Aw7aBhJuHvVC9Kis=";
      };
      zellij-what-time.src = pkgs.fetchFromGitHub {
        owner = "pirafrank";
        repo = "zellij-what-time";
        rev = "0.1.1";
        hash = "sha256-6+uNUC22RL6jbe5lqQH3Bvp8XkzNBwVbNzlt+lBQ7Ys=";
      };
      zellij-switch.src = pkgs.fetchFromGitHub {
        owner = "mostafaqanbaryan";
        repo = "zellij-switch";
        rev = "0.2.0";
        hash = "sha256-Plu/j4DaQMRtygOK0ZXOdlktxfsIzcVCYKrl2rR0dug=";
      };
      zellij-sessionizer.src = pkgs.fetchFromGitHub {
        owner = "laperlej";
        repo = "zellij-sessionizer";
        rev = "v0.4.3";
        hash = "sha256-G2O77M+0ua53WpoNBkE3sNp3yN7uv9byqIteSyEluiQ=";
      };
      zellij-jump-list.src = pkgs.fetchFromGitHub {
        owner = "blank2121";
        repo = "zellij-jump-list";
        rev = "71695202d2b7ecd0caaa27708ab8a257da675a93";
        hash = "sha256-VT/Tyc701g1eHFvBNshqC2g4JaguLtaYH0L18PFOKRU=";
      };
      zellij-favs.src = pkgs.fetchFromGitHub {
        owner = "JoseMM2002";
        repo = "zellij-favs";
        rev = "v0.1.8";
        hash = "sha256-eYnMmPyACaobOCs2Pr0X4sr8CWfQPX3uVAIa/1/BlJU=";
      };
      zellij-datetime.src = pkgs.fetchFromGitHub {
        owner = "h1romas4";
        repo = "zellij-datetime";
        rev = "v0.21.0";
        hash = "sha256-hMkzhP+4r6PLeJBOr6AZlvC+qn2HOiwQYdakOr8bkHE=";
      };
      zellij-choose-tree.src = pkgs.fetchFromGitHub {
        owner = "laperlej";
        repo = "zellij-choose-tree";
        rev = "v0.4.2";
        hash = "sha256-g6R+LfSN7IgRPWr7sf3mLIn6c2xP/oaFO/MsxX7oB0s=";
      };
      zellij-cb.src = pkgs.fetchFromGitHub {
        owner = "ndavd";
        repo = "zellij-cb";
        rev = "c82517e112ee6ab30849922901d911c4104e5763";
        hash = "sha256-q64UK36bXTEd3xcMEDNw769Ya3axcn+gJAqsM2jL8gA=";
      };
      zellij-bookmarks.src = pkgs.fetchFromGitHub {
        owner = "yaroslavborbat";
        repo = "zellij-bookmarks";
        rev = "v0.2.0";
        hash = "sha256-1sznBLKuJM3+nkozlu/bEiglscKNpqnYRv9i6TJe+io=";
      };
      zellij-autolock.src = pkgs.fetchFromGitHub {
        owner = "fresh2dev";
        repo = "zellij-autolock";
        rev = "0.2.2";
        hash = "sha256-uU7wWSdOhRLQN6cG4NvA9yASlvRwB6gggX89B5K9dyQ";
      };
      zbuffers.src = pkgs.fetchFromGitHub {
        owner = "Strech";
        repo = "zbuffers";
        rev = "v0.4.0";
        hash = "sha256-5Yrp10ONwNRryLkgbWK3WmnKVjbZH5PWvTTKbnLPDHA=";
      };
    };
  };
}
