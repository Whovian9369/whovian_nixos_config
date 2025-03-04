{
  pkgs,
  mySSHKeys,
  ...
}:
{

  /*

    # ElvishJerico seems to be the current ISO maintainer, so reach out to them
    # if required?

    ### 2025-02-22
    nix-repl> nixosConfigurations.isoimage-pc.config.image
    {
      baseName = "nixos-gnome-25.05.20250218.73cf49b-x86_64-linux";
      extension = "iso";
      fileName = "nixos-gnome-25.05.20250218.73cf49b-x86_64-linux.iso";
      filePath = "iso/nixos-gnome-25.05.20250218.73cf49b-x86_64-linux.iso";
      modules = «error: The option `image.modules' was accessed but has no value defined. Try setting the option.»;
    }
    ### 2025-02-22

    image = {
    # Defaults
      baseName = "nixos";
        # Defaults to config.system.nixos.distroId
          # config.system.nixos.distroId = "nixos"
      fileName = "nixos-24.11.20240607.051f920-x86_64-linux.iso";
        # "iso-image.nix" says that it defaults to
          # "${config.isoImage.isoBaseName}.iso"
        # "installation-cd-base.nix" seems to default it as
          # "${config.isoImage.isoBaseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso"
        # "installation-cd-base.nix" seems to be the canonical here.
      edition = "gnome";
        # Defaults to an empty string
        # "gnome" is set due to using
          # "installation-cd-graphical-gnome.nix"
      volumeID = "nixos-gnome-24.11-x86_64";
        # Defaults to "nixos${optionalString (config.isoImage.edition != "") "-${config.isoImage.edition}"}-${config.system.nixos.release}-${pkgs.stdenv.hostPlatform.uname.processor}";
      prependToMenuLabel = "";
        # Defaults to an empty string
      appendToMenuLabel = "";
        # Defaults to an empty string
    };
  */

  /*
    # Filename prefix seems to be "broken" for my purpose, so removing this
    # option. Unfortunate, but it is what it is.
    image.baseName = "Whovian-nixos";
      # Defaults to config.system.nixos.distroId
        # config.system.nixos.distroId simply output... "nixos" lol
      # I'm adding "Whovian-" in front because I like marking that
        # it's a custom image.
  */

  isoImage.edition = "mate";

  services.displayManager = {
    sddm.enable = true;
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };

  services.xserver = {
    enable = true;
    desktopManager.mate.enable = true;
  };

  environment.systemPackages = [
    pkgs._7zz
    pkgs.bat
    pkgs.dhex
    pkgs.fd
    pkgs.file
    pkgs.git
    pkgs.lynx
    pkgs.ncdu
    pkgs.progress
    pkgs.ripgrep
    pkgs.sshfs
    pkgs.terminator
    pkgs.wget
    pkgs.xxd
    pkgs.yq
    # xil.packages.x86_64-linux.xil
  ];

  nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

  programs = {
    nano.enable = true;
    screen.enable = true;
    zsh = {
      enable = true;
      shellInit = '' zsh-newuser-install () {} '';
      /*
        Disable "zsh/newuser" since this is a Live-DVD!
        I just want a working shell to use, please.
        See https://www.zsh.org/mla/users/2007/msg00396.html for
        some conversation about this unchanged feature! ...
        17 years later!
      */
      # Honestly unsure if I should be using `programs.zsh.envExtra`
      # or `programs.zsh.localVariables` here.
    /*
      localVariables = {
        DISABLE_MAGIC_FUNCTIONS = true;
      };
    */
      ohMyZsh = {
        enable = true;
        theme = "bira";
        plugins = [
          "git"
          "sudo"
        ];
      };
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.root.openssh.authorizedKeys.keys = mySSHKeys;
    users.nixos.openssh.authorizedKeys.keys = mySSHKeys;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
