{ pkgs, ... }:
let
  cliPackages = with pkgs; [
    bat
    below
    bottom
    curl
    csvlens
    difftastic

    erdtree
    fd

    git
    ffmpeg-full
    imagemagick
    iperf
    unstable.jujutsu

    nh
    nil
    nixd
    nixfmt

    ripgrep
    unrar
    unzip
    wget

    zellij
  ];

  cliPackagesExtra = with pkgs; [
    #awscli2
    binsider
    chafa
    fq
    gh
    jq
    msedit

    yt-dlp
  ];
in
{
  inherit cliPackages cliPackagesExtra;
}
