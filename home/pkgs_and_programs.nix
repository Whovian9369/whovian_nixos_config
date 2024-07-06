{
  aaru,
  agenix,
  pkgs,
  system,
  xil,
  ...
}:
let

  # Especially for dotnet packages, remember to update "/flake.nix" too!
  my_packages = {
    binaryobjectscanner = pkgs.callPackage ./packages/binaryobjectscanner/package.nix {};
    hactoolnet-bin = pkgs.callPackage ./packages/hactoolnet-bin/package.nix {};
    ird_tools = pkgs.callPackage ./packages/ird_tools/package.nix {};
    irdkit = pkgs.callPackage ./packages/irdkit/package.nix {};
    nxtik = pkgs.callPackage ./packages/nxtik/package.nix {};
    ps3dec = pkgs.callPackage ./packages/ps3dec/package.nix {};
    rom-properties = pkgs.callPackage ./packages/rom-properties/package.nix {};
    sabretools = pkgs.callPackage ./packages/sabretools/package.nix {};
    # rom-properties_ninja = pkgs.callPackage ./package.nix { useNinja = true; };
    # rom-properties_gtracker = pkgs.callPackage ./package.nix { useTracker = true; };
    # rom-properties_ninja_gtracker = pkgs.callPackage ./package.nix { useNinja = true; useTracker = true; };
    new_rclone = pkgs.rclone.overrideAttrs (oldAttrs: rec {
        patches = [ ./packages/new_rclone/patches/rclone_8ffe3e462cbf5688c37c54009db09d8dcb486860.diff ];
      }
    );
    unnix_script = pkgs.writeShellApplication {
      name = "unnix";
      /* runtimeInputs = [ sed ]; */
      text = '' sed -r 's@/nix/store/[0-9a-z]{32}-@/<nix store path>/@g' '';
        # Quick command to remove Nix Store paths from output. Original source:
        # https://trofi.github.io/posts/247-NixOS-22.05-release.html
    };
  };
in
{
  programs = {
    bat = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = false;
      enableNushellIntegration = false;
      # loadInNixShell = true;
    };

    git = {
      enable = true;
      userName = "Whovian9369";
      userEmail = "Whovian9369@gmail.com";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };

    jq = {
      enable = true;
    };

    nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
    };

    ripgrep = {
      enable = true;
    };

    zsh = {
      enable = true;
      # Honestly unsure if I should be using `programs.zsh.envExtra` or
      # `programs.zsh.localVariables` here.
      localVariables = {
        DISABLE_MAGIC_FUNCTIONS = true;
      };
      # enableAutosuggestions = true;
      # enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
        theme = "bira";
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = [
    pkgs._7zz
    pkgs.bat
    pkgs.binwalk
    pkgs.cdecrypt
    pkgs.colorized-logs
    pkgs.croc
    pkgs.dhex
    pkgs.doctl
    pkgs.fd
    pkgs.fq
    pkgs.file
    pkgs.gdrive3
    pkgs.git
    pkgs.hactool
    pkgs.instaloader
    pkgs.internetarchive
    pkgs.lynx
    pkgs.megatools
    pkgs.ncdu
    pkgs.ndstool
    pkgs.nixfmt-classic
    pkgs.progress
    pkgs.pyrosimple
    pkgs.python3
    pkgs.python3Packages.nsz
    pkgs.quickbms
    pkgs.sshfs
    pkgs.unrar-wrapper
    pkgs.wget
    pkgs.xxd
    pkgs.yq

    my_packages.binaryobjectscanner
    my_packages.ird_tools
    my_packages.irdkit
    my_packages.new_rclone
    my_packages.nxtik
    my_packages.ps3dec
    my_packages.rom-properties
    my_packages.sabretools
    my_packages.unnix_script # It's a one-line bash script
    # my_packages.hactoolnet-bin

    agenix.packages.${system}.default
    xil.packages.${system}.xil
    aaru.packages.${system}.git
   ];

  # Disabled Packages
  /*
    pkgs.binutils
      # Just use "nix shell nixpkgs#binutils -c strings -- INPUT"
    pkgs.mpv
      # Not needed on WSL
    pkgs.p7zip
      # Replaced in favour of nixpkgs#_7zz
    pkgs.rclone
      # Replaced with my_packages.new_rclone which is a patched build.
    pkgs.screen
      # Replaced with System-set "programs.screen.enable"
    pkgs.terminator
      # Not needed on WSL, even though I'd like it on WSL sometimes.
    pkgs.yt-dlp
      # Not needed on WSL
    my_packages.hactoolnet-bin
      # Not needed on WSL as I currently use the Windows version.
  */

  /*
    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses.
    # Maybe you want to install Nerd Fonts with a limited number of fonts?
    (pkgs.nerdfonts.override {
      fonts = [
        "FantasqueSansMono"
      ];
    })
  */

}
