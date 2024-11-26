{
  lib,
  osConfig,
  ...
}:
{
  home.shellAliases = {
    # From Nix environment
      "7z" = "7zz";
        # "7zz" is from "nixpkgs#_7zz"
      "termbin" = "nc termbin.com 9999";
        # Alias that lets me upload text to https://termbin.com/
        # Mainly so I can lazily upload build logs.
  } // lib.optionalAttrs (osConfig.wsl.enable or false) {
  # From Windows "%PATH%"
    "adb" = "adb.exe";
    "aaru6exe"="/mnt/c/Users/Whovian/Downloads/Games/Tools/aaru/v6.0.0-alpha9/aaru-6.0.0-alpha9_windows_x64/aaru.exe";
    "caja" = "wsl-open";
    "hactoolnet" = "hactoolnet.exe";
    "mpv" = "mpv.com";
    "tailscale" = "tailscale.exe";
    "yt-dlp" = "yt-dlp.exe";
    "7zexe" = "/mnt/c/Program\\ Files/7-Zip/7z.exe";
  };
}
