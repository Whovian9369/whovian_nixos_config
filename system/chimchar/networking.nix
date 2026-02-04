{ pkgs, ... }:
{
  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    resolved = {
      enable = false;
      settings.Resolve = {
        DNSSEC = "true";
        FallbackDNS = [
           "1.1.1.1"
           "1.0.0.1"
         ];
        DNSOverTLS = "true";
      };
    };
  };

  networking = {
    resolvconf.enable = true;
    firewall = {
      interfaces = {
        enp1s0f0 = {
          allowedTCPPorts = [ 5900 5800 ];
          allowedUDPPorts = [ 5900 5800 ];
        };
      };
    };
  };
}
