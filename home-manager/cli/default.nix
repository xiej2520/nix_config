{ pkgs, ... }:
let
  cliPackages = with pkgs; [
    bat
    bottom
    curl
    csvlens
    difftastic

    erdtree
    fd
    fzf

    gh
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
    wget
    
    zellij
  ];
  
  cliPackagesExtra = with pkgs; [
    #awscli2
    binsider
    chafa
    fq
    jq
    msedit

    yt-dlp
  ];
in
{
  cliPackages = cliPackages;
  cliPackagesExtra = cliPackagesExtra;
}
