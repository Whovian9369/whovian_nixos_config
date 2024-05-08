{
  description = "Whovian9369's WSL NixOS Config";
  inputs = {

    ### Basically required
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nixos-wsl = { 
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
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
      inputs.home-manager.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my_packages = {
      url = "/home/whovian/.flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xil = {
      url = "github:Qyriad/Xil";
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

  outputs = { self, nixpkgs, nixos-wsl, agenix, home-manager, my_packages, xil, ... }:
  {
    nixosConfigurations = {
      nixos-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
          nixos-wsl.nixosModules.wsl
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              # users.whovian = import ./home/home.nix;
              sharedModules = [
                ./home/home.nix
                agenix.homeManagerModules.default
              ];

              users.whovian.home.packages = [
                agenix.packages.x86_64-linux.default

              ];

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              extraSpecialArgs = {
                system = "x86_64-linux";
                inherit my_packages;
                inherit xil;
                my_pkgs = my_packages.packages.x86_64-linux;
              };
            };
          }
        ];
      };
    };
  };
}
