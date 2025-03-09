{ lib, pkgs, config, modulesPath, ... }:
{
  services.udev = {
    enable = true;
    extraRules = ''
      # Nintendo Switch - RCM Mode
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", ATTRS{idproduct}=="7321", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{manufacturer}=="NVIDIA Corp.", ATTRS{product}=="APX", MODE="0666"

      # Nintendo Switch - nxdumptool USB Dumping
      SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"
    '';
      /*
        First rule is access to do Nintendo Switch RCM Payload injection.

        Second rule is access to nxdumptool/nxdumpclient USB Dumping.
        Taken from github:v1993/nxdumpclient - /data/71-nxdumptool.rules
      */
  };
}
