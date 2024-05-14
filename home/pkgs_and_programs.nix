{
  agenix,
  pkgs,
  system,
  xil,
  ...
}:
{
  programs = {
    bat = {
      enable = true;
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
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
      enable = false;
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

  home.packages = [
    pkgs._7zz
    pkgs.bat
    pkgs.binwalk
    pkgs.cdecrypt
    pkgs.colorized-logs
    pkgs.croc
    pkgs.dhex
    pkgs.fd
    pkgs.file
    pkgs.gdrive3
    pkgs.git
    pkgs.hactool
    pkgs.instaloader
    pkgs.internetarchive
    pkgs.lynx
    pkgs.megatools
    pkgs.ncdu
    pkgs.nixfmt-classic
    pkgs.progress
    pkgs.pyrosimple
    pkgs.python3
    pkgs.quickbms
    pkgs.rclone
    pkgs.screen
    pkgs.sshfs
    pkgs.unrar-wrapper
    pkgs.wget
    pkgs.xxd
    pkgs.yq

    # my_pkgs.irdkit
    # my_pkgs.ird_tools
    # my_pkgs.rom-properties

    agenix.packages.${system}.default
    xil.packages.${system}.xil
   ];

  /*
    Disabled
      pkgs.binutils
        # Instead just do `nix shell nixpkgs#binutils -c strings -- INPUT.ext > INPUT.ext.strings
      pkgs.mpv
      pkgs.terminator
      pkgs.yt-dlp
      pkgs.p7zip
        # Replaced in favour of nixpkgs#_7zz
    Disabled
  */

  /*
    # It is sometimes useful to fine-tune packages, for example, by applying
    # overrides. You can do that directly here, just don't forget the
    # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  */

}
