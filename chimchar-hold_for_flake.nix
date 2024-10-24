{
  description = "Whovian9369's WSL NixOS Config";
  inputs = {

    ### Basically required
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    ### My extra inputs

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
        # Optional, not necessary for the module
      inputs.darwin.follows = "";
        # Optionally choose not to download darwin deps
        # (saves some resources on Linux)
      inputs.systems.follows = "nix-systems_default";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xil = {
      url = "github:Qyriad/Xil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Lix! Lix! Lix!

    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
      flake = false;
    };

    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    #########
    # Extra inputs that I am adding just to make my life easier,
    # but don't like that they're included >:(
    #########

    # I don't like `flake-utils`, but so many things use it that I might as
    # well only keep a single version of it.
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems_default";
    };

    # Ditto to github:nix-systems/default
    nix-systems_default = {
      url = "github:nix-systems/default";
    };

  }; # inputs

  outputs = { 
    # Needed
    self, nixpkgs,
    # Lix
    lix-module,
    # Added by me
    agenix, home-manager, nix-index-database, xil, ... }:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = {
      chimchar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/nix_lix.nix
            # Enable Nix fork "Lix" instead of default "Nix" version from
            # upstream
          ./system/users.nix
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            system.configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";
            system.stateVersion = "24.05";

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users = {
                whovian = {
                  home = {
                    homeDirectory = "/home/whovian";
                    stateVersion = "23.05";
                  };
                  imports = [
                    # ./home/home.nix
                    agenix.homeManagerModules.default
                    nix-index-database.hmModules.nix-index
                  ];
                };
              };

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              extraSpecialArgs = {
                system = "x86_64-linux";
                inherit xil;
                inherit nixpkgs;
                pkgs = import nixpkgs {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                };
                inherit agenix;
              };
            };
          }
        ];
      };
    };
  };
}
