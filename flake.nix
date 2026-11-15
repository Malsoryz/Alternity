{
  description = "Main flake for nixos and home-manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-config = {
      url = "path:./system";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    home-config = {
      url = "path:./home";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs: {
    nixosConfigurations = inputs.nixos-config.nixosConfigurations;
    homeConfigurations = inputs.home-config.homeConfigurations;
  };
}
