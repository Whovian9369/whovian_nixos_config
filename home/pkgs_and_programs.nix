{
  lib,
  aaru,
  agenix,
  osConfig,
  ihaveahax-nur,
  ninfs,
  nix-game-preservation,
  nixexprs,
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
    psfo = pkgs.callPackage ./packages/psfo/package.nix {};
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

    command-not-found = {
      enable = false;
      dbPath = "${nixexprs}/programs.sqlite";
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
      # Maybe `programs.zsh.shellInit`?
      localVariables.DISABLE_MAGIC_FUNCTIONS = true;
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
    pkgs.binary-object-scanner
    pkgs.binwalk
    pkgs.cdecrypt
    pkgs.colorized-logs
    pkgs.croc
    pkgs.dhex
    pkgs.fd
    pkgs.file
    pkgs.fq
    pkgs.gdrive3
    pkgs.git
    pkgs.hactool
    pkgs.internetarchive
    pkgs.itch-dl
    pkgs.lftp
    pkgs.lgogdownloader
    pkgs.libplist
    pkgs.lynx
    pkgs.megatools
    pkgs.ncdu
    pkgs.ndstool
    pkgs.nixfmt-rfc-style
    pkgs.progress
    pkgs.pyrosimple
    pkgs.python3
    pkgs.rclone
    pkgs.sshfs
    pkgs.unrar
    pkgs.wget
    pkgs.wiimms-iso-tools
    pkgs.xxd
    pkgs.yq

    # my_packages.binaryobjectscanner
    my_packages.ird_tools
    my_packages.irdkit
    my_packages.nix-init_packagenix # Yay for patched apps :)

    my_packages.nxtik
    my_packages.ps3dec
    my_packages.psfo
    my_packages.unnix_script # It's a one-line bash script

    aaru.packages.${system}.git
    agenix.packages.${system}.default
    ihaveahax-nur.packages.${system}."3dstool"
    ihaveahax-nur.packages.${system}.ctrtool
    ninfs.packages.${system}.ninfs
    nix-game-preservation.packages.${system}.sabretools-git
    # xil.packages.${system}.xil

  ] ++ lib.optionals (!osConfig.wsl.enable or false) [
    pkgs.acpi
    pkgs.dino
    pkgs.dosage
    pkgs.filezilla
    pkgs.fusee-nano
    pkgs.hunspell
    pkgs.hunspellDicts.en-us-large
    pkgs.imhex
    pkgs.libreoffice-qt
    pkgs.liferea
    pkgs.mpv
    pkgs.obsidian
    pkgs.scrcpy
    pkgs.terminator
    pkgs.unofficial-homestuck-collection
    pkgs.wezterm
    pkgs.yt-dlp

    # Comics
    pkgs.yacreader
    pkgs.mcomix
    # Comics

    (pkgs.discord.override { withMoonlight = true; })

    my_packages.hactoolnet
  ] ++ lib.optionals (osConfig.wsl.enable or true) [
    pkgs.wsl-open
      # Don't really need this outside of WSL
  ];

  /*
    # Disabled Packages
    pkgs.binutils
      # Just use "nix shell nixpkgs#binutils -c strings -- INPUT"
    pkgs.ctrtool
      # Using ctrtool from ihaveahax's NUR Repo.
    pkgs.nixfmt-classic
      # nixfmt was renamed to nixfmt-classic.
      # The nixfmt attribute may be used for the new RFC 166-style formatter in
      # the future, which is currently available as nixfmt-rfc-style
    pkgs.python3Packages.nsz
      # Eh, don't want it in my current config.
    pkgs.p7zip
      # Replaced in favour of nixpkgs#_7zz
    # pkgs.quickbms
      # 2024-12-31 Broken in Hydra
      # also tbh I wasn't using it anyway
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
