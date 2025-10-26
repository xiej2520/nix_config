{ config, pkgs, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    xwayland
    xwayland-satellite
  ];

  programs = {
    niri.enable = true;
    xwayland.enable = true;
  };

	#xdg.configFile."niri/config.kdl".source = ./config.kdl;
}