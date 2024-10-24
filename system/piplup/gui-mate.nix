services.xserver = {
  enable = true;
  desktopManager.mate.enable = true; # NOTE: This already installs the Engrampa archive manager
  excludePackages = [ pkgs.xterm ];
};
environment.systemPackages = with pkgs; [
  networkmanagerapplet
  unzip
  firefox
];

## Obviously not everything, but blehh
