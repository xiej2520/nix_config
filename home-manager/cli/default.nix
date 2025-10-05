{ pkgs, ... }:
let
  cliPackages = with pkgs; [
    awscli2

    git
    ffmpeg-full
    imagemagick
    iperf
    unstable.msedit

    nh
    nil
    nixd
    nixfmt-rfc-style
    
    unrar
  ];
in
{
  cliPackages = cliPackages;
}
