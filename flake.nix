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
      inputs.flake-compat.follows = "flake-compat";
    };

    ### My extra inputs

    nixexprs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
      # Used for programs.command-not-found.dbPath

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

    aaru = {
      url = "github:Whovian9369/aaru-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rom-properties = {
      url = "github:Whovian9369/rom-properties-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ninfs = {
      url = "github:ihaveamac/ninfs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ihaveahax-nur = {
      url = "github:ihaveamac/nur-packages/staging";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Lix! Lix! Lix!

    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix";
        /*
          Future me, the pattern for using Forgejo URLs is:
          git+https://git@${domain}/${user_org}/${repo}?ref=refs/tags/${TAG}
          git+https://git@${domain}/${user_org}/${repo}?rev=${commitHash}
        */
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
        /*
          Future me, the pattern for using Forgejo URLs is:
          git+https://git@${domain}/${user_org}/${repo}?ref=refs/tags/${TAG}
          git+https://git@${domain}/${user_org}/${repo}?rev=${commitHash}
        */
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    #########
    # Extra inputs that I am adding just to make my life easier,
    # but don't like that they're included >:(
    #########

    /*
      Used by:
      - lix
      - nixos-wsl
    */
    flake-compat = {
      url = "github:edolstra/flake-compat";
    };

    /*
      Used by:
      - lix-module
      - xil
    */
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "nix-systems_default";
    };

    /*
      Used by:
      - agenix
      - flake-utils
    */
    nix-systems_default = {
      url = "github:nix-systems/default";
    };


  }; # inputs

  outputs = { 
    # Needed
    self, nixpkgs, nixos-wsl,
    # Lix
    lix, lix-module,
    # Added by me
    aaru, agenix, home-manager, ihaveahax-nur, ninfs, nix-index-database, nixexprs, rom-properties, xil, ... }:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };

    inherit (import ./system/common/sshKeys.nix) mySSHKeys;
  in
  {
    # Notes
      /*
        $ nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
          should let me build the system config without calling "nixos-rebuild"

        $ nix build .#nixosConfigurations.nixos-wsl.config.system.build.toplevel
          should let me build the "nixos-wsl" system config.

        TODO: Change isoimage-pc to use "nixos-rebuild build-image --image-variant" "iso" or "iso-installer"?

        How to build ISO:
          Building .#nixosConfigurations.isoimage-pc.config.system.build.isoImage
          should build ISO to "result" (or other set) symlink.
          Alternatively, use:
          - nix build -L .#packages.x86_64-linux.build_isoimage-pc
          - nix build -L .#build_isoimage-pc

        How to use config in an install:
          Mount partitions.
          $ sudo nixos-install -v --root /mnt --flake "github:Whovian9369/whovian_nixos_config#CONFIG_NAME"
        Example for nixosConfigurations.piplup:
          $ sudo nixos-install -v --root /mnt --flake "github:Whovian9369/whovian_nixos_config#piplup"
      */

    nixosConfigurations = {
      nixos-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit aaru agenix home-manager ihaveahax-nur ninfs nix-index-database nixexprs xil rom-properties mySSHKeys;
        };
        modules = [
          ./system/shared_imports.nix
          ./system/nixos-wsl/main.nix
          # ./system/dotnet_os_codename-workaround.nix
            # Source of this fix file is
            # https://github.com/nazarewk-iac/nix-configs
            #   /modules/ascii-workaround.nix
          nixos-wsl.nixosModules.wsl
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            system = {
              configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";
              extraSystemBuilderCmds = "ln -s ${self.sourceInfo.outPath} $out/src";
            };
          }
        ];
      };

      # MacBook Pro 9,2
      chimchar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          # inherit aaru home-manager xil;
          # inherit agenix nix-index-database rom-properties mySSHKeys;
          inherit aaru agenix home-manager ihaveahax-nur ninfs nix-index-database nixexprs xil rom-properties mySSHKeys;
        };
        modules = [
          ./system/shared_imports.nix
          ./system/chimchar/main.nix
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            system = {
              configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";
              extraSystemBuilderCmds = "ln -s ${self.sourceInfo.outPath} $out/src";
            };
          }
        ];
      };

      # Currently for VMs
      piplup = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit aaru agenix home-manager ihaveahax-nur ninfs nix-index-database nixexprs xil rom-properties mySSHKeys;
        };
        modules = [
          ./system/shared_imports.nix
          ./system/piplup/main.nix
          # ./system/dotnet_os_codename-workaround.nix
            # Source of this fix file is
            # https://github.com/nazarewk-iac/nix-configs
            #   /modules/ascii-workaround.nix
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            system = {
              configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";
              extraSystemBuilderCmds = "ln -s ${self.sourceInfo.outPath} $out/src";
            };
          }
        ];
      };

      # Mainly for that broken Dell XPS
      nixps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/shared_imports.nix
          ./system/nixps/main.nix
          home-manager.nixosModules.home-manager
          {
            system = {
              configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";
              extraSystemBuilderCmds = "ln -s ${self.sourceInfo.outPath} $out/src";
            };
          }
        ];
      };

      # I love being able to generate ISOs
      isoimage-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit mySSHKeys; };
        modules = [
          # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
          ./system/isoimage-pc/main.nix
          ./system/common/nix_lix.nix
          lix-module.nixosModules.default
        ];
      };
    };

    formatter.x86_64-linux = pkgs.nixfmt-rfc-style;
      /*
        Some options:
        - nixpkgs.legacyPackages.x86_64-linux.alejandra
        - nixpkgs.legacyPackages.x86_64-linux.nixfmt
        - nixpkgs.legacyPackages.x86_64-linux.nixfmt-classic
        - nixpkgs.legacyPackages.x86_64-linux.treefmt
          - Didn't figure it out
          - Seems too... "Meh"

        Related but not formatters:
        - nixpkgs.legacyPackages.x86_64-linux.deadnix
      */

    packages.x86_64-linux = {
      binaryobjectscanner = pkgs.callPackage ./home/packages/binaryobjectscanner/package.nix {};
      hactoolnet = pkgs.callPackage ./home/packages/hactoolnet/package.nix {};
      hactoolnet-bin = pkgs.callPackage ./home/packages/hactoolnet/bin.nix {};
      ird_tools = pkgs.callPackage ./home/packages/ird_tools/package.nix {};
      irdkit = pkgs.callPackage ./home/packages/irdkit/package.nix {};
      nxtik = pkgs.callPackage ./home/packages/nxtik/package.nix {};
      ps3dec = pkgs.callPackage ./home/packages/ps3dec/package.nix {};
      psfo = pkgs.callPackage ./home/packages/psfo/package.nix {};
      sabretools = pkgs.callPackage ./home/packages/sabretools/package.nix {};

      new_nix-init = pkgs.nix-init.overrideAttrs (oldAttrs: {
          patches = [ ./home/packages/nix-init/default_to_package.diff ];
        } );

      build_isoimage-pc = self.nixosConfigurations.isoimage-pc.config.system.build.isoImage;
    };
  };
}
