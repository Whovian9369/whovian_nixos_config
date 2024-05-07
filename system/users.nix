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
        initialPassword = "abcde"; # I need to log in somehow
        shell = pkgs.zsh;
      };
    };
  };
}
