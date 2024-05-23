# Whovian's system flake
I needed to put my config into a `git` repo, so I made my first system config flake (and added my `home-manager` setup too.) and committed it.
If you have suggestions on "fixing" or "cleaning up" my configurations, please add it to the [Discussions](about:blank) so I can take a look at it later!

### Future reference:
- [[github:eclairevoyant/flake-migration - /nixos.md] "How to switch to flakes from path-based nix"](https://github.com/eclairevoyant/flake-migration/blob/main/nixos.md)

- [[NixOS-WSL GitHub/Site] "How to configure NixOS-WSL with flakes?"](https://nix-community.github.io/NixOS-WSL/howto.html)

- [[Xe Iaso] Nix Flakes on WSL](https://xeiaso.net/blog/nix-flakes-4-wsl-2022-05-01/)

- [[Home-Manager GitHub/Site] Setting up `home-manager` as a NixOS module.](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module)

- [[github:LGUG2Z/nixos-wsl-starter] "A sane, batteries-included starter template for running NixOS on WSL"](https://github.com/LGUG2Z/nixos-wsl-starter)

- [[githubL:ashebanow Starred - Example Nix Configs] "These are other people's nix configs I've found useful, informative, and/or inspirational."](https://github.com/stars/ashebanow/lists/example-nix-configs/)

### Notes for possible future use:
```nix
virtualisation.docker = {
  enableOnBoot = true;
  autoPrune.enable = true;
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

  registry = {
    nixpkgs = {
      flake = inputs.nixpkgs;
    };
  };
  nixPath = [
    "nixpkgs=${inputs.nixpkgs.outPath}"
  ];

  gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
};
```

### Information Backups:
```bash
$ sudo nix-channel --list
nixos https://nixos.org/channels/nixos-23.11
nixos-wsl https://github.com/nix-community/NixOS-WSL/archive/refs/heads/main.tar.gz
```
