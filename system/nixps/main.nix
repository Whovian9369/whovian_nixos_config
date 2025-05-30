{
 lib,
 config,
 pkgs,
 ...
}:

{
  imports =
    [ 
      ./packages.nix # Package list
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ./gui.nix # WM/DE settings? Hopefully it works????
      ./docker.nix # Docker
      ./tailscale.nix # Tailscale
      ./udev.nix # custom udev rules
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixps"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  security.rtkit.enable = true;

#### /etc/nixos/gui.nix ####

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

#### /etc/nixos/gui.nix ####

#### /etc/nixos/users.nix ####

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.whovian = {
  #   name = "whovian";
  #   description = "Whovian9369";
  #   shell = pkgs.zsh;
  #   isNormalUser = true;
  #   extraGroups = [ 
  #     "networkmanager" 
  #     "wheel" # Enable ‘sudo’ for the user.
  #   ];
  #   openssh = {
  #     authorizedKeys = {
  #      keys = [
  #        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5E4BLKTeFAeRdIMJbdi1ZcphWF3WnJAZ6FX6zbKHI3" # NixOS WSL
  #      ];
  #     };
  #    };
    # packages = with pkgs; [
    #   firefox
    #   tree
    # ];
  # };

#### /etc/nixos/users.nix ####

#### /etc/nixos/packages.nix ####

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # services.openssh.settings.PermitRootLogin = "no";

#### /etc/nixos/packages.nix ####

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

##############################################################################

  /*
    This option defines the first version of NixOS you have installed on this particular machine,
    and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.

    Most users should NEVER change this value after the initial install, for any reason,
    even if you've upgraded your system to a new NixOS release.

    This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    to actually do that.

    This value being lower than the current NixOS release does NOT mean your system is
    out of date, out of support, or vulnerable.

    Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    and migrated your data accordingly.

    For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  */
  system.stateVersion = "23.11";
}
