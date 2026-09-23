{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  programs = {
    niri = {
      enable = true;
      useNautilus = false;
    };
    xwayland.enable = true;
  };

  xdg.portal = {
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.niri.default = lib.mkForce [ "kde" ];
    config.niri."org.freedesktop.impl.portal.FileChooser" =  lib.mkForce [ "kde" ];
  };
}
