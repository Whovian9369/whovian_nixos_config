{ pkgs, ... }:
{
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
  networking.firewall = {
    interfaces = {
      enp1s0f0 = {
        allowedTCPPorts = [ 5900 5800 ];
        allowedUDPPorts = [ 5900 5800 ];
      };
    };
  };
}
