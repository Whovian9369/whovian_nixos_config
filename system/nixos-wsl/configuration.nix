{ lib,
  pkgs,
  config,
  modulesPath,
  nixos-wsl,
  ...
}:

{
  imports = [
    ./packages.nix
    ./users.nix
    ./wsl.nix
  ];

  networking.hostName = "nixos-wsl";

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
  */
  environment.pathsToLink = [
    "/share/zsh"
  ];

  system.stateVersion = "22.05";
}
