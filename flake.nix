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
    };

    ### My extra inputs

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
        # optional, not necessary for the module
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my_packages = {
      url = "/home/whovian/.flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }; # inputs

  outputs = { self, nixpkgs, nixos-wsl, agenix, home-manager, my_packages, ... }:
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
                my_pkgs = my_packages.packages.x86_64-linux;
              };
            };
          }
        ];
      };
    };
  };
}
