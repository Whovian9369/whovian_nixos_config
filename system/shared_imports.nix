{
  lib,
  aaru,
  agenix,
  config,
  flake-programs-sqlite,
  home-manager,
  ihaveahax-nur,
  ninfs,
  nixpkgs,
  pkgs,
  rom-properties,
  xil,
  ...
}:

{
  imports = [
    ./common/nix_lix.nix
    ./common/users.nix
    ./common/fonts.nix
  ];

  # Optionally, use home-manager.extraSpecialArgs to pass arguments
  # to home.nix
  # I really hope that setting it this way won't screw anything up! 🙃
  home-manager.extraSpecialArgs = {
    system = "x86_64-linux";
    inherit aaru;
    inherit agenix;
    # inherit nixpkgs;
    inherit ihaveahax-nur;
    inherit ninfs;
    inherit rom-properties;
    inherit xil;
    # pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
    inherit pkgs;
  };
}
