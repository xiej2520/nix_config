{ pkgs, ... }:
let
  cliPackages = with pkgs; [
    git
    ffmpeg-full
    iperf

    nh
    nil
    nixd
    nixfmt-rfc-style
  ];
in
{
  cliPackages = cliPackages;
}
