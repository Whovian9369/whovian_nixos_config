{
  # Mostly from https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
  programs.hyprland.enable = true; # enable Hyprland

  environment.systemPackages = [
    # ... other packages
    pkgs.kitty # required for the default Hyprland config
  ];

  # Optional, hint Electron apps to use Wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";


  # If your themes for mouse cursors, icons or windows don’t load correctly, see
  # the relevant section in Hyprland on Home Manager.
  # Which is likely https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#faq
}
