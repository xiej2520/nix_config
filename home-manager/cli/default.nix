{ pkgs, ... }:
let
  cliPackages = with pkgs; [
    awscli2
    bat
    bottom
    curl
    difftastic
    erdtree
    fd

    git
    ffmpeg-full
    imagemagick
    iperf
    jujutsu
    unstable.msedit

    nh
    nil
    nixd
    nixfmt-rfc-style
    
    ripgrep
    unrar
    wget
  ];
in
{
  cliPackages = cliPackages;
}
