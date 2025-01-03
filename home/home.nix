{
  lib,
  agenix,
  specialArgs,
  system,
  ...
}:
{
  imports = [
    ./pkgs_and_programs.nix # home.packages and programs
    ./dotfiles.nix # home.file
    ./variables.nix # home.sessionVariables
    ./aliases.nix # home.shellAliases
    # ./rust.nix # Should be my `rustfmt` config.
      # I no longer have an interest in Rust. :)
  ];

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "whovian";
    homeDirectory = "/home/whovian";

    /*
    This value determines the Home Manager release that your configuration is
    compatible with. This helps avoid breakage when a new Home Manager release
    introduces backwards incompatible changes.
    
    You should not change this value, even if you update Home Manager. If you do
    want to update the value, then make sure to first check the Home Manager
    release notes.
    */
    stateVersion = "23.05"; # Please read the comment before changing.

    # Let Home Manager install and manage itself.
    # Probably not needed for a module?
    # programs.home-manager.enable = true;
  };

  /* age = {
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
      itchy = {
        file = ./secrets/itchy.age;
      };
      elixire = {
        file = ./secrets/elixire.age;
      };
    };
  };
  */
}
