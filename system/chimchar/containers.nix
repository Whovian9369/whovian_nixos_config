{
  virtualisation = {
    docker = {
      enable = false;
      extraOptions = ''
      '';
      logDriver = "journald";
        # Currently set to the default "journald" but sometimes I like making sure
        # that I know it's set that way.
      storageDriver = "overlay2";
        /*
          From module at ${nixpkgs}/nixos/modules/virtualisation/docker.nix
          github:NixOS/nixpkgs/commit/953f72e76ec2379b28894a2457a372666c4d1acc
          "aufs"
          "btrfs"
          "devicemapper"
          "overlay"
          "overlay2"
          "zfs"
        */
    };
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };
}
