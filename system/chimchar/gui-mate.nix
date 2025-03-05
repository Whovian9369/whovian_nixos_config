{
  lib,
  pkgs,
  rom-properties,
  ...
}:

{
  imports = [ ./audio.nix ];

  services = {
    displayManager.sddm.enable = true;
    xserver = {
      enable = true;
      desktopManager = {
        mate = {
          enable = true;
            # NOTE: This already installs the Engrampa archive manager
          extraCajaExtensions = [
            rom-properties.packages.x86_64-linux.rp_gtk3
          ];
        };
      };
    };
  };
}
