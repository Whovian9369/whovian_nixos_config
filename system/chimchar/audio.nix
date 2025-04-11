{
  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services = {
    pulseaudio = {
      enable = true;
      systemWide = false;
      # systemWide = true;
    };
    pipewire = {
      enable = false;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
  };
}
