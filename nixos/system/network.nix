{ config, pkgs, ... }:
{
  ### Networking
  networking.hostName = "WORKING_DESKTOP";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    # Open ports in the firewall.
    allowedTCPPorts = [ /*80 443*/ 8080 ];
    #allowedUDPPortRanges = [
    #  { from = 4000; to = 4007; }
    #  { from = 8000; to = 8010; }
    #];
  };

}

