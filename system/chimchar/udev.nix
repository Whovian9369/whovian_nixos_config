{ lib, pkgs, config, modulesPath, ... }:
{
  services.udev = {
    enable = true;
    /*
      First set of rules are for Nintendo Switch RCM Payload injection.

      Second rule is access to nxdumptool/nxdumpclient USB Dumping. Taken from
      github:v1993/nxdumpclient - /data/71-nxdumptool.rules

      Third rule is to access PongoOS, a lower level shell at iBoot(?) level
      Taken from github:matteyeux/autodecrypt - /66-pongos.rules
    */
    extraRules = ''
      # Nintendo Switch - RCM Mode
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0955", ATTRS{idproduct}=="7321", MODE="0666"
      SUBSYSTEM=="usb", ATTRS{manufacturer}=="NVIDIA Corp.", ATTRS{product}=="APX", MODE="0666"

      # Nintendo Switch - nxdumptool USB Dumping
      SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"

      # Handle PongoOS
      # ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05ac", ATTR{idProduct}=="4141", OWNER="root", GROUP="plugdev", MODE="0660"
      SUBSYSTEM=="usb", ATTR{idVendor}=="05ac", ATTR{idProduct}=="4141", MODE="0666"
    '';
  };
}
