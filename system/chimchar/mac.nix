{ pkgs, config, ... }:
{
  # Explicitly set libinput stuff
  services.libinput = {
    enable = true;
    touchpad = {
      horizontalScrolling = true;
      scrollMethod = "twofinger";
      naturalScrolling = false;
    };
  };
}