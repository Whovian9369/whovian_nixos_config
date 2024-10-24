{
  aaru,
  agenix,
  home-manager,
  ninfs,
  nixpkgs,
  pkgs,
  rom-properties,
  xil,
  ...
}:
# let inherit (import ./system/1_common/sshKeys.nix) mySSHKeys; in
{
  imports = [
    ./common/nix_lix.nix
    ./common/users.nix
  ];

  # Optionally, use home-manager.extraSpecialArgs to pass arguments
  # to home.nix
  # I really hope that setting it this way won't screw anything up! 🙃
  home-manager.extraSpecialArgs = {
    system = "x86_64-linux";
    inherit aaru;
    inherit agenix;
    # inherit nixpkgs;
    inherit ninfs;
    inherit rom-properties;
    inherit xil;
    # pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
    inherit pkgs;
  };
}
