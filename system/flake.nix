{
  description = "NixOS/System Flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    import-tree.url = "github:denful/import-tree";

    #  Packages: System only
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Packages: Global
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    altpkgs.url = "path:../packages";
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

      stable-pkgs = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations."aru" = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs stable-pkgs; };
        modules = [
          ./configuration.nix # Configuration

          # Flake inputs modules
          inputs.chaotic.nixosModules.default
          inputs.noctalia.nixosModules.default

          # Autoload modules
          (inputs.import-tree.filter (path: !inputs.nixpkgs.lib.hasSuffix ".ignore.nix" path) ./modules)
        ];
      };
    };
}
