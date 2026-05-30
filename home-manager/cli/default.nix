{ pkgs, ... }:
let
  cliPackages = with pkgs; [
    #awscli2
    bat
    binsider
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
    msedit

    nh
    nil
    nixd
    nixfmt

    ripgrep
    unrar
    wget
  ];
in
{
  cliPackages = cliPackages;
}
