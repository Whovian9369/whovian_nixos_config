{
  lib,
  aaru,
  agenix,
  osConfig,
  ninfs,
  pkgs,
  rom-properties,
  system,
  xil,
  ...
}:
let

  # Especially for dotnet packages, remember to update "/flake.nix" too!
  my_packages = {
    binaryobjectscanner = pkgs.callPackage ./packages/binaryobjectscanner/package.nix {};
    hactoolnet = pkgs.callPackage ./packages/hactoolnet/package.nix {};
    hactoolnet-bin = pkgs.callPackage ./packages/hactoolnet/bin.nix {};
    ird_tools = pkgs.callPackage ./packages/ird_tools/package.nix {};
    irdkit = pkgs.callPackage ./packages/irdkit/package.nix {};
    nxtik = pkgs.callPackage ./packages/nxtik/package.nix {};
    ps3dec = pkgs.callPackage ./packages/ps3dec/package.nix {};
    sabretools = pkgs.callPackage ./packages/sabretools/package.nix {};
    new_rclone = pkgs.rclone.overrideAttrs (oldAttrs: rec {
        patches = [ ./packages/new_rclone/patches/rclone_8ffe3e462cbf5688c37c54009db09d8dcb486860.diff ];
      }
    );
    nix-init_packagenix = pkgs.nix-init.overrideAttrs (oldAttrs: rec {
        patches = [ ./packages/nix-init/default_to_package.diff ];
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
    pkgs.ctrtool
    pkgs.dhex
    pkgs.fd
    pkgs.file
    pkgs.fq
    pkgs.gdrive3
    pkgs.git
    pkgs.hactool
    pkgs.internetarchive
    pkgs.lynx
    pkgs.megatools
    pkgs.ncdu
    pkgs.ndstool
    pkgs.nixfmt-rfc-style
    pkgs.progress
    pkgs.pyrosimple
    pkgs.python3
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
    my_packages.nix-init_packagenix # Yay for patched apps :)

    my_packages.nxtik
    my_packages.ps3dec
    my_packages.sabretools
    my_packages.unnix_script # It's a one-line bash script

    aaru.packages.${system}.git
    agenix.packages.${system}.default
    ninfs.packages.${system}.ninfs
    rom-properties.packages.${system}.default
    # xil.packages.${system}.xil
   ] ++ lib.optionals (!osConfig.wsl.enable or false) [
    pkgs.mpv
    pkgs.terminator
    pkgs.yt-dlp

    my_packages.hactoolnet
   ];

  /*
    # Disabled Packages
    pkgs.binutils
      # Just use "nix shell nixpkgs#binutils -c strings -- INPUT"
    pkgs.nixfmt-classic
      # nixfmt was renamed to nixfmt-classic.
      # The nixfmt attribute may be used for the new RFC 166-style formatter in the future, which is currently available as nixfmt-rfc-style
    pkgs.python3Packages.nsz
      # Eh, don't want it in my current config.
    pkgs.p7zip
      # Replaced in favour of nixpkgs#_7zz
    pkgs.rclone
      # Replaced with my_packages.new_rclone which is a patched build.
    pkgs.screen
      # Replaced with system-set "programs.screen.enable"
    my_packages.hactoolnet-bin
      # Not needed on WSL as I currently use the Windows version.
      # Not needed otherwise as I currently use the self-built version.

    # Not included in WSL, but included otherwise:
    pkgs.mpv
      # Not needed on WSL
    pkgs.terminator
      # Not needed on WSL, even though I'd like it on WSL sometimes.
    pkgs.yt-dlp
      # Not needed on WSL
    my_packages.hactoolnet
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
