{
  home.shellAliases = {
  # From Windows "%PATH%"
    "adb" = "adb.exe";
    "caja" = "explorer.exe";
    "hactoolnet" = "hactoolnet.exe";
    "mpv" = "mpv.com";
    "tailscale" = "tailscale.exe";
    "yt-dlp" = "yt-dlp.exe";
    "7zexe" = "/mnt/c/Program\\ Files/7-Zip/7z.exe";

  # From Nix environment
    "7z" = "7zz";
      # "7zz" is from "nixpkgs#_7zz"
    "termbin" = "nc termbin.com 9999";
      # Alias that lets me upload text to https://termbin.com/
      # Mainly so I can lazily upload build logs.
  };
}
