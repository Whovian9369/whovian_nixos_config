{ lib,
  pkgs,
  config,
  modulesPath,
  ...
}:
{
  users = {
    groups = {
      usb = {};
    };
    users = {
      whovian = {
        name = "whovian";
        description = "Whovian";
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
            # Enable 'sudo' for the user.
          "usb"
            # This should enable access to usb devices.
          "docker"
            # Enable 'docker' for the user.
        ];
        openssh = {
          authorizedKeys = {
            keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5E4BLKTeFAeRdIMJbdi1ZcphWF3WnJAZ6FX6zbKHI3" # NixOS WSL
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFaYZLW6/jmYOun4BdSYDbwyHXYfS3FzlaFjgflpakyb" # JuiceSSH
            ];
          };
        };
      };
    };
  };
}
