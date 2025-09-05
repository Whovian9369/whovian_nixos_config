{ lib, agenix, pkgs, config, modulesPath, ... }:
{
  environment.systemPackages = [
    pkgs.file
    pkgs.xterm
    # `agenix` is currently added via
    # home-manager's `home.packages`
  ];

  programs = {
    firefox.enable = true;
    nano.enable = true;
    screen.enable = true;
    zsh.enable = true;
  };
}
