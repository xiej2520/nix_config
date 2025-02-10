{ config, pkgs, ... }:

{
  ### services (programs in background):

  # this setups a ssh server. very important if you're setting up a headless system.
  # feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # opinionated: forbid root login through ssh.
      PermitRootLogin = "no";
      # opinionated: use keys only.
      # remove if you want to ssh using passwords
      PasswordAuthentication = false;
    };
  };

  ### desktop environment
  # enable the x11 windowing system.
  # you can disable this if you're only using the wayland session.
  services.xserver.enable = true;

  # enable the kde plasma desktop environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # configure keymap in x11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.onedrive.enable = true;

  # enable cups to print documents
  services.printing.enable = true;

  # enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # if you want to use jack applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # enable touchpad support (enabled default in most desktopmanager).
  # services.xserver.libinput.enable = true;
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };

}
