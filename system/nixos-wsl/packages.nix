{ lib, agenix, pkgs, config, modulesPath, ... }:
{
  environment.systemPackages = [
    pkgs.file
    pkgs.xterm
    # `agenix` is currently added via
    # home-manager's `home.packages`
  ];


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

    cdemu = {
      # I haven't figured out how to get `cdemu` properly working (in WSL), so
      # I'm just going to leave it as `programs.cdemu.enable = false;` for now.
      enable = false;
      group = "cdrom";
      gui = false;
      image-analyzer = false;
    };

    screen = {
      enable = true;
    };

  };

  # `documentation.man.generateCaches` seems to be mainly useful for `whatis`,
  # but I couldn't really get it working well.
  # From what I can tell, it depends on a package being installed via
  # `environment.systemPackages`, *and* for that package to have a manpage.
  # That's kinda useless for me since I've been mostly installing stuff via
  # `home-manager`, sooooooooo...
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
}
