{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}:

{
  imports = [
    ./packages.nix
  ];

  networking.hostName = "my_nixos_vm";

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

  environment.pathsToLink = [
    "/share/zsh"
  ];

  system.stateVersion = "22.05";
}
