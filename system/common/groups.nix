{
  myWslGroups = [
    "wheel"
      # Enable 'sudo' for the user.
  ];

  myHardwareGroups = [
    "wheel"
      # Enable 'sudo' for the user.
    "networkmanager"
      # Enable use of NetworkManager
    "usb"
      # This should enable access to usb devices.
    "docker"
      # Enable 'docker' for the user.
  ];

  users.groups = {
    usb = {
      # Placeholder to create group.
    };
  };
}
