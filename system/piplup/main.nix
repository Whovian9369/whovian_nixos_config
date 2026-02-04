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
    ./packages.nix
      # Package list
    ./hardware-configuration.nix
      # Include the results of the hardware scan.
    ./gui-cinnamon.nix
      # GUI Stuff (DE + WM)
    ./gui-kde6.nix
      # GUI Stuff (DE + WM)
    ./gui-mate.nix
      # GUI Stuff (DE + WM)
    ./gui-xfce.nix
      # GUI Stuff (DE + WM)
    ./vmware.nix
      # VMWare Guest Stuff
  ];

  networking = {
    hostName = "piplup";
    networkmanager.enable = true;
  };

  # Enable nix flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "America/New_York";

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

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };

  users.users.whovian = {
    openssh.authorizedKeys.keys = mySSHKeys;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  environment = {
    shells = [
      pkgs.zsh
    ];
    pathsToLink = [
      "/share/zsh"
    ];
  };

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
  system.stateVersion = "26.05";
}
