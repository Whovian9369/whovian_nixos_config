{
  lib,
  pkgs,
  rom-properties,
  ...
}:
{
  # Use PipeWire
  security.rtkit.enable = true;

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
  # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  # Fonts
  fonts.enableDefaultPackages = false;
  fonts.packages = [
    # fonts.enableDefaultPackages
    pkgs.dejavu_fonts
    pkgs.freefont_ttf
    pkgs.gyre-fonts # TrueType substitutes for standard PostScript fonts
    pkgs.liberation_ttf
    pkgs.unifont
    pkgs.noto-fonts-color-emoji
    # fonts.enableDefaultPackages
    pkgs.comic-mono
    pkgs.corefonts
    pkgs.inconsolata
    pkgs.monocraft
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.unifont_upper
  ];
  fonts.fontconfig.cache32Bit = true;
  # dconf
  programs.dconf.enable = true;
  # KDE6
  # Enable the KDE Desktop Environment.
  xdg.icons.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = [
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
}
