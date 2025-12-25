{ pkgs, ... }:
let
  cliPackages = with pkgs; [
    awscli2
    bat
    binsider
    bottom
    curl
    csvlens
    difftastic
    erdtree
    fd

    gh
    git
    ffmpeg-full
    imagemagick
    iperf
    unstable.jujutsu
    lazygit
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
