# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ ... }:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../common.nix
    ./bootloader.nix
    ./network.nix
    ./packages.nix
    ./services.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nix.settings = {
    # STOP OOM
    cores = 32;
    max-jobs = 4;
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "xiej" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  programs.ssh.startAgent = true;

  users.users = {
    xiej = {
      isNormalUser = true;
      # openssh.authorizedKeys.keys = [ ];
      extraGroups = [
        # "adbusers" # android studio
        "kvm"
        "networkmanager"
        # "podman" # equivalent to root
        "wheel"
      ];

      # podman
      subUidRanges = [ { startUid = 100000; count = 65536; } ];
      subGidRanges = [ { startGid = 100000; count = 65536; } ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  # https://nixos.org/manual/nixos/stable/release-notes
  system.stateVersion = "26.05"; # Did you read the comment?
}

