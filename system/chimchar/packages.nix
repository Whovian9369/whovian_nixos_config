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

    ### Scanning
    (pkgs.epsonscan2.override { withGui = true; withNonFreePlugins = true; })
    ### Scanning

    ### iOS Stuff
    pkgs.libimobiledevice
    pkgs.ifuse
      # optional, to mount using 'ifuse'
    pkgs.checkra1n
    pkgs.libusbmuxd
    ### iOS Stuff
  ];

  programs = {
    adb.enable = true;
    firefox.enable = true;
    flashrom.enable = true;
    nano.enable = true;
    nm-applet.enable = true;
    screen.enable = true;
    zsh.enable = true;

    cdemu = {
      enable = true;
      group = "cdrom";
      gui = true;
      image-analyzer = true;
    };
    mosh = {
      enable = true;
      openFirewall = false;
    };
  };

  services.fwupd = {
    enable = true;
    daemonSettings = {
      DisabledPlugins = [
        "test"
        "test_ble"
        "invalid"
        "bios"
      ];
    };
  };
}
