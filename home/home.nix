{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  # Change into current path
  configurationPath = "/home/alternity/dotfiles";

  antigravity-code = pkgs.symlinkJoin {
    name = "antigravity-code";
    paths = [ pkgs.antigravity-ide ];
    postBuild = ''
      ln -s $out/bin/antigravity-ide $out/bin/code
    '';
  };
in
{
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  home.username = "alternity";
  home.homeDirectory = "/home/alternity";
  home.stateVersion = "26.05";
  home.packages = with pkgs; [
    # Apps
    qbittorrent
    vlc
    zapfast
    gnome-system-monitor

    openssl
    tree
    curl
    wget
    fastfetch
    unzip
    eza
    bat
    unrar

    (python3.withPackages (
      ppkgs: with ppkgs; [
        pip
        numpy
      ]
    ))

    jetbrains-mono

    # formatter
    nixfmt

    php85
    php85Packages.composer
  ];

  home.shellAliases = {
    system-rebuild = "sudo nixos-rebuild switch --flake ${configurationPath}#aru";
    system-boot-rebuild = "sudo nixos-rebuild boot --flake ${configurationPath}#aru";
    system-test-rebuild = "sudo nixos-rebuild test --flake ${configurationPath}#aru";

    home-rebuild = "home-manager switch --flake ${configurationPath}#alternity";

    all-rebuild = "sudo nixos-rebuild switch --flake ${configurationPath}#aru && home-manager switch --flake ${configurationPath}#alternity";

    ls = "${pkgs.eza}/bin/eza --icons";
    ll = "${pkgs.eza}/bin/eza -lah --icons";
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.antigravity}/bin/antigravity";
    NIX_CONFIG_PATH = configurationPath;
  };

  # Programs --------------------------------------------- #

  programs = {
    #  Apps
    chromium = {
      enable = true;
      package = pkgs.google-chrome;
    };

    discord.enable = true;
    bun.enable = true;
    opencode.enable = true;
    onlyoffice.enable = true;
    obsidian.enable = true;

    # Development
    antigravity = {
      enable = true;
      package = antigravity-code;
    };

    git = {
      enable = true;
      settings = {
        user.name = "Malsoryz";
        user.email = "ikmalalansory@gmail.com";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          ServerAliveInterval = 60;
          ServerAliveCountMax = 3;
        };
        "github.com" = {
          User = "git";
          ForwardAgent = true;
          IdentityFile = "~/.ssh/id_ed25519";
        };
      };
    };

    npm = {
      enable = true;
      package = pkgs.nodejs_24;
    };

    uv.enable = true;
    ruff.enable = true;

    # Terminal
    # kitty = {
    #   enable = true;
    #   package = pkgs.kitty;
    #   font = {
    #     name = "JetBrainsMono Nerd Font";
    #     package = pkgs.nerd-fonts.jetbrains-mono;
    #   };
    #   settings = {
    #     background = "#120000";
    #     background_opacity = "0.75";
    #     window_padding_width = 12;
    #   };
    # };

    alacritty.enable = true;

    fish = {
      enable = true;
      shellInit = ''
        fish_add_path $HOME/.local/bin
      '';
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # Important
  programs.home-manager.enable = true;
}
