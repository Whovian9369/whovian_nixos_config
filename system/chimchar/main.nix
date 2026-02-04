{
  lib,
  pkgs,
  config,
  modulesPath,
  agenix,
  mySSHKeys,
  nix-index-database,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
      # Include the results of the hardware scan.
    ./packages.nix
      # environment.systemPackages, nixpkgs config, and related.
    ./firmware.nix
      # hardware.firmware - Mainly just to add appropriate drivers for some
      # hardware, like USB bluetooth adapters.

    ./gui-cinnamon.nix
      # GUI Stuff - Cinnamon
    ./gui-mate.nix
      # GUI Stuff - MATE
    ./gui-xfce.nix
      # GUI Stuff - XFCE

    ./battery.nix
       # Battery/Power Saving stuff.
    ./containers.nix
      # Podman or Docker settings.
    ./ios.nix
      # iOS Tooling.
    ./mac.nix
      # Extra Mac settings
    # ./mpd.nix
      # Music
    ./networking.nix
      # Various extra networking related options.
    ./printing_scanning.nix
      # Printer and Scanner stuff
    ./udev.nix
      # Extra udev rules
    ./securitykeys.nix
      # Security Key stuff
  ];

  networking = {
    hostName = "chimchar";
    enableB43Firmware = lib.mkDefault true;
    networkmanager = {
      enable = true;
      # dns = "systemd-resolved";
      plugins = [ ];
      # settings = { };
    };
  };

  boot = {
    # tmp.cleanOnBoot = true;
    loader.systemd-boot = {
      enable = true;
      editor = false;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.whovian = {
    openssh.authorizedKeys.keys = mySSHKeys;
  };

  environment.shells = [
    pkgs.zsh
  ];

  # Enable nix flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.tailscale.enable = true;

  time.timeZone = "America/New_York";

  environment.pathsToLink = [
    "/share/zsh"
  ];

  /*
    Add environment.pathsToLink for auto-completion for system packages (e.g. systemd).
    Appears to be required due to [GitHub - nix-community/home-manager]:
    https://github.com/nix-community/home-manager/blob/c781b28add41b74423ab2e64496d4fc91192e13a/modules/programs/zsh.nix#L348-L358
      [/modules/programs/zsh.nix]
    https://github.com/nix-community/home-manager/issues/3521#issuecomment-1367197995
      [Issue #3521]

    06 June 2024:
    Appears to be handled by "programs.zsh.enableCompletion" being enabled.
    https://github.com/NixOS/nixpkgs/blob/49f6869f71fb2724674ccc18670bbde70843d43f/nixos/modules/programs/zsh/zsh.nix#L305
    I appear to have "programs.zsh.enableCompletion" disabled for some reason?
    Need to look into this again at some point, I suppose.
  */

##############################################################################

  /*
    This option defines the first version of NixOS you have installed on this particular machine,
    and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.

    Most users should NEVER change this value after the initial install, for any reason,
    even if you've upgraded your system to a new NixOS release.

    This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    to actually do that.

    This value being lower than the current NixOS release does NOT mean your system is
    out of date, out of support, or vulnerable.

    Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    and migrated your data accordingly.

    For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  */
  system.stateVersion = "25.05";
}
