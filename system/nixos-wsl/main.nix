{
  lib,
  agenix,
  config,
  mySSHKeys,
  nix-index-database,
  nixos-wsl,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    ./packages.nix
    ./wsl.nix
  ];

  networking.hostName = "nixos-wsl";

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

  time.timeZone = "America/New_York";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      whovian = {
        imports = [
          ../../home/home.nix
          agenix.homeManagerModules.default
          nix-index-database.homeModules.nix-index
        ];
      };
    };
  };

  /*
  services.nixseparatedebuginfod2 =
    enable = true;
    subsituters = {};
  };
  */


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
  system.stateVersion = "22.05";
}
