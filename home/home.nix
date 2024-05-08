{
  config,
  pkgs,
  my_pkgs,
  xil,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "whovian";
  home.homeDirectory = "/home/whovian";

  /*
  This value determines the Home Manager release that your configuration is
  compatible with. This helps avoid breakage when a new Home Manager release
  introduces backwards incompatible changes.
  
  You should not change this value, even if you update Home Manager. If you do
  want to update the value, then make sure to first check the Home Manager
  release notes.
  */
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs = {
    config = {
      allowUnfree = true;
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
    my_pkgs.ird_tools
    my_pkgs.rom-properties

    # Why does this *just* work? Blehh :P
    # Is it because "$(nix run github:Qyriad/Xil)" works?
    xil
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

  age = {
    identityPaths = [
      /home/whovian/.ssh/id_ed25519.nix
    ];
    secrets = {
      cursed = {
        file = ./secrets/curse.age;
      };
      openai = {
        file = ./secrets/openai_key.age;
      };
    };
  };

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

  home.file = {
    /*
      # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # symlink to the Nix store copy.
      ".screenrc".source = dotfiles/screenrc;

      # You can also set the file content immediately.
      ".gradle/gradle.properties".text = ''
       org.gradle.console=verbose
       org.gradle.daemon.idletimeout=3600000
      '';
    */

    ".zshrc".text = ''
      eval "$(direnv hook zsh)"

      download_nixpkgs_cache_index () {
        filename="index-$(uname -m | sed 's/^arm64$/aarch64/')-$(uname | tr A-Z a-z)"
        mkdir -p ~/.cache/nix-index && cd ~/.cache/nix-index
        # -N will only download a new version if there is an update.
        wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
        ln -f $filename files
      }
    '';

    ".lftp/rc".text = ''
      alias s32 "mirror -c --use-pget-n=32"
      alias p32 "pget -n 32 -c"
      alias p16 "pget -n 16 -c"
      alias s16 "mirror -c --use-pget-n=16"
      alias p8 "pget -n 8 -c"
      alias ssl "set ssl:verify-certificate false"
    '';
  };

  home.sessionVariables = {
    EDITOR = "nano";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    OPENAI_API_KEY = "\$(cat ${config.age.secrets."openai".path})";
    CURSEFORGE_API_KEY = "\$(cat ${config.age.secrets."cursed".path})";
  };

  home.shellAliases = {
    "adb" = "adb.exe";
    "caja" = "explorer.exe";
    "hactoolnet" = "hactoolnet.exe";
    "mpv" = "mpv.com";
    "tailscale" = "tailscale.exe";
    "yt-dlp" = "yt-dlp.exe";
    "7zexe" = "/mnt/c/Program\\ Files/7-Zip/7z.exe";
    "7z" = "7zz";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
