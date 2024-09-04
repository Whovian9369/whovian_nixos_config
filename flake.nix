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

    # Ditto to github:edolstra/flake-compat
    flake-compat = {
      url = "github:edolstra/flake-compat";
    };

  }; # inputs

  outputs = { 
    # Needed
    self, nixpkgs, nixos-wsl,
    # Lix
    lix, lix-module,
    # Added by me
    agenix, home-manager, nix-index-database, xil, aaru, rom-properties, ... }:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };

    inherit (import ./system/sshKeys.nix) mySSHKeys;
  in
  {
    # Notes
      /*
        $ nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
          should let me build the system config without calling "nixos-rebuild"

        $ nix build .#nixosConfigurations.nixos-wsl.config.system.build.toplevel
          should let me build the "nixos-wsl" system config.

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
        modules = [
          ./system/nixos-wsl/configuration.nix
          # ./system/dotnet_os_codename-workaround.nix
            # Source of this fix file is
            # https://github.com/nazarewk-iac/nix-configs
            #   /modules/ascii-workaround.nix
          ./system/nix_lix.nix
          ./system/users.nix
          nixos-wsl.nixosModules.wsl
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            system.configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";

            users.users.whovian = {
              openssh.authorizedKeys.keys = mySSHKeys;
            };

            environment.shells = [
              pkgs.zsh
            ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users = {
                whovian = {
                  imports = [
                    ./home/home.nix
                    agenix.homeManagerModules.default
                    nix-index-database.hmModules.nix-index
                  ];
                };
              };

              # Optionally, use home-manager.extraSpecialArgs to pass arguments
                # to home.nix
              extraSpecialArgs = {
                system = "x86_64-linux";
                inherit aaru;
                inherit agenix;
                inherit nixpkgs;
                inherit rom-properties;
                inherit xil;
                pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
              };
            };

            # services.nixseparatedebuginfod.enable = true;
          }
        ];
      };

      isoimage-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
          {

          /*

            isoImage = {
            # Defaults
              isoName = "nixos-24.11.20240607.051f920-x86_64-linux.iso";
                # "iso-image.nix" says that it defaults to
                  # "${config.isoImage.isoBaseName}.iso"
                # "installation-cd-base.nix" seems to default it as
                  # "${config.isoImage.isoBaseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso"
                # "installation-cd-base.nix" seems to be the canonical here.
              isoBaseName = "nixos";
                # Defaults to config.system.nixos.distroId
                  # config.system.nixos.distroId = "nixos"
              edition = "gnome";
                # Defaults to an empty string
                # "gnome" is set due to using
                  # "installation-cd-graphical-gnome.nix"
              volumeID = "nixos-gnome-24.11-x86_64";
                # Defaults to "nixos${optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"}-${config.system.nixos.release}-${pkgs.stdenv.hostPlatform.uname.processor}";
              prependToMenuLabel = "";
                # Defaults to an empty string
              appendToMenuLabel = "";
                # Defaults to an empty string
            };

          */

            isoImage = {
              isoBaseName = "Whovian-nixos";
                # Defaults to config.system.nixos.distroId
                  # config.system.nixos.distroId simply output... "nixos" lol
                # I'm adding "Whovian-" in front because I like marking that
                  # it's a custom image.
            };

            environment.systemPackages = [
              pkgs._7zz
              pkgs.bat
              pkgs.dhex
              pkgs.fd
              pkgs.file
              pkgs.git
              pkgs.lynx
              pkgs.ncdu
              pkgs.progress
              pkgs.ripgrep
              pkgs.sshfs
              pkgs.terminator
              pkgs.wget
              pkgs.xxd
              pkgs.yq
              # xil.packages.x86_64-linux.xil
            ];

            nix.extraOptions = ''
                experimental-features = nix-command flakes
              '';

            programs = {
              nano.enable = true;
              screen.enable = true;
              zsh = {
                enable = true;
                shellInit = '' zsh-newuser-install () {} '';
                /*
                  Disable "zsh/newuser" since this is a Live-DVD!
                  I just want a working shell to use, please.
                  See https://www.zsh.org/mla/users/2007/msg00396.html for
                  some conversation about this unchanged feature! ...
                  17 years later!
                */
                # Honestly unsure if I should be using `programs.zsh.envExtra`
                # or `programs.zsh.localVariables` here.
              /*
                localVariables = {
                  DISABLE_MAGIC_FUNCTIONS = true;
                };
              */
                ohMyZsh = {
                  enable = true;
                  theme = "bira";
                  plugins = [
                    "git"
                    "sudo"
                  ];
                };
              };
            };

            users = {
              defaultUserShell = pkgs.zsh;
              users.root.openssh.authorizedKeys.keys = mySSHKeys;
              users.nixos.openssh.authorizedKeys.keys = mySSHKeys;
            };

            services.openssh = {
              enable = true;
              settings = {
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
              };
            };
          }
        ];
      };

      piplup = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
         specialArgs = { inherit rom-properties; };
        modules = [
          ./system/piplup/configuration.nix
          # ./system/dotnet_os_codename-workaround.nix
            # Source of this fix file is
            # https://github.com/nazarewk-iac/nix-configs
            #   /modules/ascii-workaround.nix
          ./system/nix_lix.nix
          ./system/users.nix
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            system.configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";

            boot.loader.systemd-boot = {
              enable = true;
              editor = false;
            };

            users.users.whovian = {
              openssh.authorizedKeys.keys = mySSHKeys;
            };

            services.openssh = {
              enable = true;
              settings = {
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
              };
            };

            environment.shells = [
              pkgs.zsh
            ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users = {
                whovian = {
                  imports = [
                    ./home/home.nix
                    agenix.homeManagerModules.default
                    nix-index-database.hmModules.nix-index
                  ];
                };
              };

              # Optionally, use home-manager.extraSpecialArgs to pass arguments
                # to home.nix
              extraSpecialArgs = {
                system = "x86_64-linux";
                inherit aaru;
                # inherit xil;
                inherit nixpkgs;
                pkgs = import nixpkgs {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                };
                inherit rom-properties;
                inherit agenix;
              };
            };
          }
        ];
      };

    /*  nixps = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/xps/configuration.nix
            # ./system/xps/users.nix
            home-manager.nixosModules.home-manager
            {
              system.configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                users = {
                  whovian = {
                    imports = [
                      ./home/home.nix
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
    */
    };

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

      new_rclone = pkgs.rclone.overrideAttrs ( oldAttrs: {
          patches = [ ./home/packages/new_rclone/patches/rclone_8ffe3e462cbf5688c37c54009db09d8dcb486860.diff ];
        } );
      new_nix-init = pkgs.nix-init.overrideAttrs (oldAttrs: {
          patches = [ ./home/packages/nix-init/default_to_package.diff ];
        } );

      build_isoimage-pc = self.nixosConfigurations.isoimage-pc.config.system.build.isoImage;
      external_lix = lix.packages.x86_64-linux.nix;
      external_xil = xil.packages.x86_64-linux.xil;
      external_aaru = aaru.packages.x86_64-linux.git;
      external_rom-properties = rom-properties.packages.x86_64-linux.default;
    };
  };
}
