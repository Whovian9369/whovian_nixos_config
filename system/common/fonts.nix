{
  lib,
  config,
  pkgs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    packages = [] ++ lib.optionals (!config.wsl.enable or false) [
      ### fonts.enableDefaultPackages as of nixpkgs 7fd4e5f7c309
      pkgs.dejavu_fonts
      pkgs.freefont_ttf
      pkgs.gyre-fonts
        # TrueType substitutes for standard PostScript fonts
      pkgs.liberation_ttf
      pkgs.unifont
      pkgs.noto-fonts-color-emoji
      ### fonts.enableDefaultPackages as of nixpkgs 7fd4e5f7c309

      pkgs.corefonts

      pkgs.comic-mono
      pkgs.inconsolata
      pkgs.monocraft
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.unifont_upper
    ];
    fontconfig.cache32Bit = true;
  };
}
