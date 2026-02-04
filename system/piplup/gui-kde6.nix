{
  lib,
  pkgs,
  rom-properties,
  ...
}:
{
  imports = [ ./audio.nix ];

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = false;
    desktopManager.plasma6.enable = true;
  };

  # dconf
  programs.dconf.enable = true;

  xdg.icons.enable = true;
  programs.partition-manager.enable = true;
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = [
      pkgs.kdePackages.sddm-kcm
      pkgs.kdePackages.audiocd-kio
      pkgs.kdePackages.skanpage
      pkgs.kdePackages.isoimagewriter
      pkgs.kdePackages.krdc # RDP
      # pkgs.kdePackages.neochat # Matrix
      pkgs.exfatprogs
      pkgs.sublime4
      rom-properties.packages.x86_64-linux.rp_kde6
    ];
  };
}
