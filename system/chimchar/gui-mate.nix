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
      displayManager.lightdm.enable = true;
      # NOTE: This already installs the Engrampa archive manager
      desktopManager.mate.enable = true;
    };
  };

  environment.systemPackages = [
    rom-properties.packages.x86_64-linux.rp_gtk3
  ];
}
