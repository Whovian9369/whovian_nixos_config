{
  lib,
  config,
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
        extraGroups = [
          "wheel"
            # Enable 'sudo' for the user.
        ] ++ lib.optionals (!config.isWSL) [
        # These are the groups for baremetal machines, or possibly VMs.
          "networkmanager"
            # Enable use of NetworkManager
          "usb"
            # This should enable access to usb devices.
          "docker"
            # Enable 'docker' for the user.
        ];
      };
    };
  };
}
