{ lib, pkgs, config, modulesPath, ... }:
{
  services = {
    udev = {
      enable = true;
      extraRules = ''
        # Nintendo Switch - RCM Rule
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0955", ATTRS{idproduct}=="7321"
        SUBSYSTEMS=="usb", ATTRS{manufacturer}=="NVIDIA Corp.", ATTRS{product}=="APX"

        # Content sourced from github:v1993/nxdumpclient - `data/71-nxdumptool.rules`
        # Nintendo SDK debugger, which nxdumptool presents itself as
        SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", TAG+="uaccess"
      '';
    };
  };
}
