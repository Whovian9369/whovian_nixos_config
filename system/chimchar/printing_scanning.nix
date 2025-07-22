{
  pkgs,
  ...
  # config
}:
{
  services = {
    printing = {
      enable = true;
      drivers = [
        pkgs.brlaser
          # Drivers for some Brother printers
        pkgs.brgenml1lpr
          # Generic drivers for more Brother printers
        pkgs.brgenml1cupswrapper
          # Generic drivers for more Brother printers
      ];
        /* Available drivers for services.printing.drivers:
          pkgs.gutenprint
            # Drivers for many different printers from many different vendors.
          pkgs.gutenprintBin
            # Additional, binary-only drivers for some printers.
          pkgs.hplip
            # Drivers for HP printers.
          pkgs.hplipWithPlugin
            # Drivers for HP printers, with the proprietary plugin.
            # Use NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup' to add the printer
            # regular CUPS UI doesn't seem to work.
          pkgs.postscript-lexmark
            # Postscript drivers for Lexmark
          pkgs.samsung-unified-linux-driver
            # Proprietary Samsung Drivers
          pkgs.splix
            # Drivers for printers supporting SPL (Samsung Printer Language).
          pkgs.brlaser
            # Drivers for some Brother printers
          pkgs.brgenml1lpr
            # Generic drivers for more Brother printers
          pkgs.brgenml1cupswrapper
            # Generic drivers for more Brother printers
          pkgs.cnijfilter2
            # Drivers for some Canon Pixma devices (Proprietary driver)
        */
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
        # Opens UDP 5353
    };
  };
  hardware.sane = {
    enable = true;
      # enables support for SANE scanners
    extraBackends = [
      pkgs.epkowa
        # For Epson Perfection V600 Photo
        # http://www.sane-project.org/sane-mfgs.html#Z-EPSON
    ];
  };
}