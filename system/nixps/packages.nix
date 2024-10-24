{ lib, pkgs, config, modulesPath, ... }: {
  nix = {
    package = pkgs.nixFlakes;  
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    [
      pkgs.file
      # pkgs.xterm
      pkgs.git
      # pkgs.xfce.thunar
      pkgs.tailscale
      pkgs.blueman
      pkgs.fontconfig
    ];
  programs.zsh.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    pkgs.stdenv.cc.cc.lib # For the fucking "libstdc++.so.6"
    pkgs.icu # dotnet is missing icu shit for some reason?
  /*
    pkgs.dotnetCorePackages.runtime_8_0 # For direct dotnet apps because now everything is just packaged as binaries and not code :upside_down:
  Doesn't seem to work????
  */ 

  ];

  # Enable the OpenSSH daemon.
  services = {
    tailscale = {
      enable = true;
    };
    openssh = {
      enable = true;
      settings= {
        PermitRootLogin = "prohibit-password";
      };
    };
  };
}
