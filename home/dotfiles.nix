{
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
}
