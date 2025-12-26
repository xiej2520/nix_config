{ config, pkgs, ... }:
{
  ### Bootloader.
  # nixos-rebuild switch --install-bootloader

  #boot.loader.systemd-boot.enable = true;
  # systemd-boot needs Windows \EFI\Microsoft\Boot\bootmgfw.efi on the same drive
  # else windows can't boot... just use grub
  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
    #efi.efiSysMountPoint = "/boot";
    timeout = 30;
  };
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd"
    "zswap.max_pool_percent=20"
    "zswap.shrinker_enabled=1"
  ];
  boot.supportedFilesystems = [ "ntfs" ];
}
