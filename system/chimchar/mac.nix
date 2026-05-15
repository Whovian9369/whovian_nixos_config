{ pkgs, config, ... }:
{
  services = {
    # Enable fan controller
    mbpfan.enable = true;
    # Explicitly set libinput stuff
    libinput = {
      enable = true;
      touchpad = {
        horizontalScrolling = true;
        scrollMethod = "twofinger";
        naturalScrolling = false;
      };
    };
  };
}
