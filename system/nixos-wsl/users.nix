{ lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
{
  users = {
    users = {
      whovian = {
        name = "whovian";
        description = "Whovian9369";
        extraGroups = [
          "wheel"
          "cdrom"
        ];
        shell = pkgs.zsh;
        initialPassword = "abcde"; # I need to log in somehow
      };
    };
  };
}
