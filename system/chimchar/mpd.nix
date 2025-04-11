{
  config,
  ...
}:

{

  systemd.services = {
    mpd.environment = {
      # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
      XDG_RUNTIME_DIR = "/run/user/1000";
        # User-id must match above user.
        # MPD will look inside this directory for the PipeWire socket.
    };
  };

  services.mpd = {
    enable = true;
    musicDirectory = "/home/whovian/Music";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "Pulseaudio"
        mixer_type      "hardware"      # optional
        mixer_device    "default"       # optional
        mixer_control   "PCM"           # optional
        mixer_index     "0"             # optional
      }
    '';

    network.listenAddress = "any";
      # if you want to allow non-localhost connections
    startWhenNeeded = true;
      # systemd feature: only start MPD service upon connection to its socket
    user = "whovian";
  };

  networking.firewall = {
    # interfaces = {
      # enp1s0f0 = {
        allowedTCPPorts = [ 6600 ];
        allowedUDPPorts = [ 6600 ];
      };
    # };
  # };
}
