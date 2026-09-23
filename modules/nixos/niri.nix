{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xwayland
    xwayland-satellite
  ];

  programs = {
    niri.enable = true;
    xwayland.enable = true;
  };
}
