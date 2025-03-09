{
  lib,
  pkgs,
  rom-properties,
  ...
}:

{
  imports = [ ./audio.nix ];

  # Enable the Cinnamon Desktop Environment.
  services.displayManager.sddm.enable = true;

  services.displayManager.defaultSession = "cinnamon-wayland";

  services.xserver.desktopManager = {
    cinnamon.enable = true;
  };

  # Enable KDE Connect
  programs.kdeconnect.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

  environment = {
    cinnamon.excludePackages = [ pkgs.celluloid ];
    systemPackages = [
      rom-properties.packages.x86_64-linux.rp_gtk3
    ];
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;
}
