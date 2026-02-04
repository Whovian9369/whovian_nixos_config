{
  lib,
  pkgs,
  rom-properties,
  ...
}:

{
  imports = [ ./audio.nix ];

  # Enable the Cinnamon Desktop Environment.
  services = {
    displayManager = {
      sddm.enable = false;
      defaultSession = "cinnamon";
    };

    xserver = {
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;

      # Configure keymap in X11
      enable = true;
      xkb.layout = "us";
      xkb.variant = "";
    };

    # Enable the Cinnamon Desktop Environment.
    cinnamon.apps.enable = true;

    # Mount, trash, and other functionalities
    gvfs.enable = true;
  };

  # Enable KDE Connect
  programs.kdeconnect.enable = true;
  programs.dconf.enable = true;
  xdg.icons.enable = true;

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    cinnamon.excludePackages = [
      pkgs.celluloid
      pkgs.onboard
    ];
    systemPackages = [
      pkgs.exfatprogs
      pkgs.sublime4
      rom-properties.packages.x86_64-linux.rp_gtk3
    ];
  };
}
