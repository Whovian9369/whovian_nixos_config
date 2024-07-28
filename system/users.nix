{
  lib,
  options,
  pkgs,
  ...
}:
{
  users = {
    users = {
      whovian = {
        name = "whovian";
        description = "Whovian9369";
        shell = pkgs.zsh;
        initialPassword = "abcde"; # I need to log in somehow
        isNormalUser = true;
        extraGroups = [
          "wheel"
            # Enable 'sudo' for the user.
        ] ++ lib.optionals (!options ? wsl) [
        # These are the groups for baremetal machines, or possibly VMs.
          "docker"
            # Enable 'docker' for the user.
        ];
      };
    };
  };
}
