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

  services.displayManager.cosmic-greeter.enable = true;
  #services.displayManager.plasma-login-manager = {
  #  enable = true;
  #};
}