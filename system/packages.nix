{ lib, agenix, pkgs, config, modulesPath, ... }:
{
  environment.systemPackages = [
    pkgs.file
    pkgs.xterm
    /*
      `agenix` is currently added via
      "nixos#nixosConfigurations.nixos-wsl.modules.environment.systemPackages"
    */
    # agenix.packages.x86_64-linux.default
  ];

  /*
  documentation = {
    nixos = {
      includeAllModules = true;
    };
    man = {
      generateCaches = true;
    };
  };
  */

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  programs = {
    zsh = {
      enable = true;
    };
    nano = {
      enable = true;
    };
    /*
      I haven't figured out how to get `cdemu` properly working in WSL, so I'm
      just going to leave it as `programs.cdemu.enable = false;` for now.
    */
    cdemu = {
      enable = false;
      group = "cdrom";
      gui = false;
      image-analyzer = false;
    };
  };
}
