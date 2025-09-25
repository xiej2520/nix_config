{ pkgs, ... }:
let
  cliPackages = with pkgs; [
    git
    ffmpeg-full
    iperf
    unstable.msedit

    nh
    nil
    nixd
    nixfmt-rfc-style
  ];
in
{
  cliPackages = cliPackages;
}
