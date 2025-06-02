{ config, pkgs, ... }:
let
  basePath = "$HOME/Alternity";
  hmFlakePath = "${basePath}/home-manager/aru";
  systemFlakePath = "${basePath}/system/nixos";
in
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  home = {
    username = "aru";
    homeDirectory = "/home/aru";
    shell.enableZshIntegration = true;
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    # Utilities and CLIs
    openssh
    fastfetch
    android-tools
    cava
    htop

    # Desktop App
    google-chrome
    android-studio
    netbeans
    onlyoffice-desktopeditors
    obsidian
    gparted
    spotify
    vlc

    # Programming
    openjdk
    maven
    php
    php84Packages.composer
    nodejs_24
    mariadb
    mycli
  ];

  home.shellAliases = {
    # MUST USE THIS FOR REBUILD AND HOME-MANAGER SWITCH !!
    hm-switch = "home-manager switch --flake ${hmFlakePath}";
    rebuild = "sudo nixos-rebuild switch --flake ${systemFlakePath}";

    ls = "eza";
    la = "eza -a";
    lh = "eza -lh";
    lha = "eza -lha";

    pisan = "php artisan";
    pmi = "php artisan migrate";
    pmi-f = "php artisan migrate:fresh";
    pmi-r = "php artisan migrate:refresh";

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    dirHashes = {
      "docs" = "$HOME/Documents";
      "dotfiles" = "$HOME/.config";
      "hm-conf" = "${hmFlakePath}";
      "sys-conf" = "${systemFlakePath}";
    };
    history = {
      share = true;
      extended = true;
      ignoreSpace = true;
      size = 10000;
    };
  };

  programs.vscode.enable = true;
  programs.yt-dlp.enable = true;

  services.podman = {
    enable = true;
    autoUpdate = {
      enable = true;
      onCalendar = "Sun *-*-* 00:00:00";
    };
    settings.registries.search = [
      "docker.io"
      "ghcr.io"
    ];
  };
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
    store.cleanup = true;
  };

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    settings = {
      "initial_window_width" = "80";
      "initial_window_height" = "24";
      "placement_strategy" = "center";
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
