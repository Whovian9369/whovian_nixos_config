{ pkgs, config, ... }:
{
  hardware.firmware = [
    pkgs.linux-firmware
    pkgs.b43Firmware_6_30_163_46
      # TODO: Updated as needed?
      # Look at nixpkgs:nixos/modules/hardware/all-firmware.nix sometimes?
  ];

  boot = {
    kernelModules = [ "b43" ];
    blacklistedKernelModules = [ "wl" ];
  };
}
