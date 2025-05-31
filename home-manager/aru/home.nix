{ config, pkgs, ... }:
let
  hmFlakePath = "~/Alternity/home-manager/aru";
in
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  home = {
    username = "aru";
    homeDirectory = "/home/aru";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    openssh
    fastfetch

    # Desktop App
    google-chrome
    android-studio
    netbeans
    onlyoffice-desktopeditors
    obsidian

    # Programming
    openjdk
    maven
    php
    php84Packages.composer
    nodejs_24
    mycli
  ];

  home.shellAliases = {
    hm-switch = "home-manager switch --flake ${hmFlakePath}";

    ls = "eza";
    la = "eza -a";
    lh = "eza -lh";
    lha = "eza -lha";

    trash = "${pkgs.conceal}/bin/conceal";
    rm = "${pkgs.conceal}/bin/cnc";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Candy";
      package = pkgs.candy-icons;
    };
  };

  programs.vscode.enable = true;
  programs.yt-dlp.enable = true;

  services.podman.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
  };

  programs.git = {
    enable = true;
    userName  = "Malsoryz";
    userEmail = "ikmalalansory@gmail.com";
    delta.enable = true;
    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      crendential.helper = "store";
      core = {
        fileMode = true;
        pager = "${pkgs.delta}/bin/delta";
      };
      delta = {
        line-numbers = true;
        side-by-side = false;
      };
      interactive = {
        diffFilter = "${pkgs.delta}/bin/delta --color-only";
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        host = "github.com";
        user = "git";
        forwardAgent = true;
        identityFile = [
          "~/.ssh/id_ed25519"
        ];
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    #initExtra = ''
    #  ${motd}/bin/my-motd
    #'';
    history.size = 10000;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "always";
    colors = "auto";
    extraOptions = [
      "--group-directories-first"
      "--bytes"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;
}
