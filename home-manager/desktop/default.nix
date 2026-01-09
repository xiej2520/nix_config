{ pkgs, ... }:
let
  desktopPackages = with pkgs; [
    unstable.discord
    gimp
    handbrake

    kdePackages.dolphin
    kdePackages.filelight
    kdePackages.kclock
    kdePackages.kimageformats

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
    google-chrome
    inkscape
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
    sourcegit
  ];

  # less used
  devPlusPackages = with pkgs; [
    android-studio
    jetbrains.idea
    ghidra
    kdePackages.kompare
    kdePackages.kontrast
    okteta
    typst
    unstable.zed-editor.fhs
  ];

  gamePackages = with pkgs; [
    lutris
    moonlight-qt
    protontricks
    rpcs3
    ryubing
  ];

  fontPackages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-emoji-blob-bin
    font-awesome
    lexend
    twitter-color-emoji
  ];

  minecraftPackages = with pkgs; [
    (pkgs.cubiomes-viewer.overrideAttrs (old: {
      patches = (old.patches or []) ++ [ ../../pkgs/cubiomes-viewer-patch/0001-fix-mapview-drag-on-linux-by-lowering-threshold-for-.patch ];
    }))
    mcaselector
    prismlauncher
  ];

  miscPackages = with pkgs; [
    libjxl # cjxl
    oxipng
    x265

    unstable.ollama-rocm
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
