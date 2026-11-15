{
  description = "Home manager flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";

    # Packages: Only for home manager
    # Only override inputs in here.
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # Packages: Global
    # inputs can be overriden in main flake.
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

      stable-pkgs = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
      spicetify-pkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      homeConfigurations."alternity" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs stable-pkgs spicetify-pkgs; };
        modules = [
          ./home.nix # Configuration file

          # Flake inputs modules
          inputs.noctalia.homeModules.default
          inputs.zapfast.homeManagerModules.default
          inputs.spicetify-nix.homeManagerModules.default

          # Autoload modules
          (inputs.import-tree.filter (path: !inputs.nixpkgs.lib.hasSuffix ".ignore.nix" path) ./modules)
        ];
      };
    };
}
