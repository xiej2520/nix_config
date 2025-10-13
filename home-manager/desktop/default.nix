{ pkgs, ... }:
let
  desktopPackages = with pkgs; [
    discord
    gimp
    handbrake

    kdePackages.filelight
    kdePackages.kclock

    onedrivegui
    qdirstat

    spotify
    transmission_4-qt
    vlc

    wine
    wl-clipboard-rs
  ];

  desktopPlusPackages = with pkgs; [
    avidemux
    isoimagewriter
    mpv
    obs-studio
    shotcut

    qimgv
    vipsdisp
  ];

  # turns out nix really doesn't like this being called kdePackages
  # expected a set but found a list: [ <<thunk>> <<thunk>> ... ]
  kdeConfigPackages = with pkgs; [
    kdePackages.dolphin-plugins
    kdePackages.kdeplasma-addons
    kdePackages.plasma-nm
    kdePackages.yakuake
    klassy
    unstable.plasma-panel-colorizer
  ];

  devPackages = with pkgs; [
    github-desktop
    git-filter-repo
    gh
    lazygit
    sourcegit
  ];

  # less used
  devPlusPackages = with pkgs; [
    android-studio
    jetbrains.idea-community-bin
    ghidra
    kdePackages.kompare
    kdePackages.kontrast
    okteta
    typst
    zed-editor
  ];

  gamePackages = with pkgs; [
    lutris
    moonlight-qt
    protontricks
    rpcs3
    ryujinx
  ];

  fontPackages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-emoji-blob-bin
    font-awesome
    lexend
    twitter-color-emoji
  ];

  minecraftPackages = with pkgs; [
    cubiomes-viewer
    mcaselector
    prismlauncher
  ];

  miscPackages = with pkgs; [
    x265
  ];
in
{
  desktopPackages = desktopPackages;
  desktopPlusPackages = desktopPlusPackages;
  kdeConfigPackages = kdeConfigPackages;
  devPackages = devPackages;
  devPlusPackages = devPlusPackages;
  gamePackages = gamePackages;
  fontPackages = fontPackages;
  minecraftPackages = minecraftPackages;
  miscPackages = miscPackages;
}
