{
  lib,
  pkgs,
  rom-properties,
  ...
}:

{
  imports = [ ./audio.nix ];

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    displayManager = {
      sddm.enable = false;
    };
    xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      displayManager.lightdm.enable = true;
    };
  };

  environment.systemPackages = [
    rom-properties.packages.x86_64-linux.rp_gtk3
  ];

  programs.thunar.plugins = [
    pkgs.thunar-archive-plugin
    pkgs.thunar-volman
    pkgs.thunar-vcs-plugin
  ];

  environment.xfce.excludePackages = [
    pkgs.parole
  ];
}
