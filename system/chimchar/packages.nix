{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
{
  environment.systemPackages = [
    pkgs.distrobox
    pkgs.file
    pkgs.sublime4
    pkgs.pwvucontrol
    (pkgs.vlc.override { libbluray = pkgs.libbluray.override { withAACS = true; withBDplus = true; withJava = true; }; })
    pkgs.waypipe
    pkgs.xterm
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
    };
  };

  programs = {
    firefox.enable = true;
    nano.enable = true;
    screen.enable = true;
    zsh.enable = true;
    nm-applet.enable = true;
  };
}
