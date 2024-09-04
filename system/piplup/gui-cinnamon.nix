{
  lib,
  pkgs,
  rom-properties,
  ...
}:
{
  # Use PipeWire
  security.rtkit.enable = true;

  # dconf
  programs.dconf.enable = true;

  services = {
    # Use PipeWire
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
    # Enable the Cinnamon Desktop Environment.
    cinnamon.apps.enable = true;

    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
  };


  # Fonts
  fonts = {
    enableDefaultPackages = false;
    packages = [
    # fonts.enableDefaultPackages
      pkgs.dejavu_fonts
      pkgs.freefont_ttf
      pkgs.gyre-fonts
        # TrueType substitutes for standard PostScript fonts
      pkgs.liberation_ttf
      pkgs.unifont
      pkgs.noto-fonts-color-emoji
    # fonts.enableDefaultPackages
      pkgs.unifont_upper
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.corefonts
    ];
    fontconfig.cache32Bit = true;
  };

  # KDE6
  # Enable the KDE Desktop Environment.
  xdg.icons.enable = true;
  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = [
      pkgs.kdePackages.sddm-kcm
      pkgs.kdePackages.audiocd-kio
      pkgs.kdePackages.skanpage
      pkgs.kdePackages.isoimagewriter
      pkgs.kdePackages.krdc # RDP
      # pkgs.kdePackages.neochat # Matrix
      pkgs.kdePackages.breeze-icons
      pkgs.kdePackages.discover # "KDE and Plasma resources management GUI"
      pkgs.kdePackages.partitionmanager # Partition Manager
      pkgs.exfatprogs
      pkgs.sublime4
      rom-properties.packages.x86_64-linux.rp_kde6
      # (rom-properties.packages.x86_64-linux.rp_kde6.overrideAttrs (oldAttrs: { patches = oldAttrs.patches ++ [ ../files/rp_larger_icons.diff ]; }))
    ];
  };
}
