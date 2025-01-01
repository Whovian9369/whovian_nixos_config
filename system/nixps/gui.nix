{ lib, pkgs, config, modulesPath, ... }:
{
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services = {
  ### XFCE
    ### "services.picom" can be enabled for nice graphical effects ...
    picom = {
      enable = false;
      fade = true;
      inactiveOpacity = 0.9;
      shadow = true;
      fadeDelta = 4;
    };
  ### XFCE

    pipewire = {
      enable = true;
      # audio.enable = true;
      pulse.enable = true;
      jack.enable = true;
      # alsa = {
      #   enable = true;
      #   support32Bit = true;
      # };
    };

    displayManager = {
      defaultSession = "mate";
    };

    xserver = {
      enable = true;
        # Enable the X11 windowing system.
      videoDrivers = [ "modesetting" ];
      desktopManager = {
        xterm.enable = false;
        xfce.enable = false;
        lxqt.enable = true;
        mate.enable = true;
      };
    };
  };
}
