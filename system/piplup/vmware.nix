{
  lib,
  options,
  pkgs,
  ...
}:
{
  virtualisation.vmware.guest.enable = true;
  services.xserver.videoDrivers = [ "vmware" ];
}
