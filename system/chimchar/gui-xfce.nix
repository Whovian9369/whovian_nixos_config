{
  lib,
  pkgs,
  rom-properties,
  ...
}:

{
  imports = [ ./audio.nix ];

  services = {
    displayManager = {
      sddm.enable = false;
    };
    xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      displayManager.lightdm.enable = true;
    };
  };

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };

  programs.thunar.plugins = [
    pkgs.xfce.thunar-archive-plugin
    pkgs.xfce.thunar-volman
    rom-properties.packages.x86_64-linux.rp_gtk3
  ];

  environment.xfce.excludePackages = [
    pkgs.xfce.parole
  ];
}
