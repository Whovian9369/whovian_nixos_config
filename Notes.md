# Notes for possible future use:

`/run/udev/rules.d` exists. Might be good to remember.

-------------------------------

## Useful tools to keep track of
  - `nixpkgs#nix-bisect`
    - Hydra-aware `git bisect` support, basically?
    - `pkgs/by-name/ni/nix-bisect/package.nix`

## GUI Notes
  - Look into `nixpkgs#eww` for no real reason

### Wallpapers that I like
https://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-nineish-dark-gray.png

## Information Backups:
```bash
$ sudo nix-channel --list
nixos https://nixos.org/channels/nixos-23.11
nixos-wsl https://github.com/nix-community/NixOS-WSL/archive/refs/heads/main.tar.gz
```

Had to make a new `nixos-wsl` install approximately on 2025-08-19, but switched to flakes near immediately:
```bash
$  sudo nix-channel --list
nixos https://nixos.org/channels/nixos-25.05
nixos-wsl https://github.com/nix-community/NixOS-WSL/archive/refs/heads/release-25.05.tar.gz
```

## Options that I may want:
I really really should look further into these before actually using them. 
```nix
virtualisation.docker = {
  enableOnBoot = true;
  autoPrune = {
    enable = true;
  };
};

wsl = {
  # Enable integration with Docker Desktop (needs to be installed)
  docker-desktop.enable = false;
};

environment.shells = [pkgs.zsh];

nix = {
  settings = {
    access-tokens = [
      "github.com=${github_token-variable}"
      "gitlab.com=OAuth2:${gitlab_token-variable}"
    ];
    accept-flake-config = true;
    auto-optimise-store = true;
  };

  gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
};

networking.networkmanager.plugins = [];
```

## Yubikey, probably?
Source: https://old.reddit.com/r/NixOS/comments/170tbbj/cannot_force_yubikey_in_2fa/k3okj79/

Add this to config:
```nix
{ pkgs, ... }: {
  programs.gnupg.agent.enable = true;
  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host ];
  }
}
```

Run these commands
```bash
    $ gpg --card-status   # Verify that the hardware support works

    $ gpg --change-pin    # Change both the pin and the admin pin
                          # Default pins are 123456 and 12345678 respectively

    $ gpg --edit-card     # Issue these commands in the interactive session:
        admin             # Allow the "generate" command to be used
        key-attr          # Tell it you want RSA 4096
        generate          # Several interactive prompts.
                          # Asks for user pin first and admin pin second.
                          # and touch the key.

    $ pamu2fcfg           # Put this in security.pam.u2f.authFile.
                          # pamu2fcfg is in the pam_u2f package.

    # ykman is in the yubikey-manager package.
    $ ykman config usb --disable OTP       # Optional: Don't emit gibberish when bumped.
    $ ykman openpgp keys set-touch sig on  # Optional: Require key to be touched on use
    $ ykman openpgp keys set-touch enc on
    $ ykman openpgp keys set-touch aut on
    $ ykman openpgp keys set-touch att on
```

```nix
{ pkgs, ... }: {
  security.pam.u2f.control = "required";
  security.pam.u2f.enable = true;
  security.pam.u2f.authFile = pkgs.writeText "u2f-auth-file" ''
    <gibberish from running `pamu2fcfg`>
  '';
}
```
