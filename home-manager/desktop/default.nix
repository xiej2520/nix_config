{ pkgs, ... }:
let
  desktopPackages = with pkgs; [
    unstable.discord
    gimp
    handbrake
    kdePackages.kolourpaint

    kdePackages.kclock
    #kdePackages.kimageformats # tga doesn't work?

    lan-mouse
    onedrivegui
    qdirstat

    mpv
    spotify
    transmission_4-qt
    # add dav1d for AV1 playback
    (vlc.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ dav1d ];
    }))

    wine
    wl-clipboard-rs
  ];

  # included with plasma6.nix
  kdeBaseDesktopPackages = with pkgs; [
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.elisa
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.spectacle
  ];

  desktopPlusPackages = with pkgs; [
    google-chrome
    inkscape
    kdePackages.isoimagewriter
    kdePackages.filelight
    kdePackages.kdenlive
    obs-studio

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
    git-filter-repo
    sourcegit
    # unstable.zed-editor
  ];

  # less used, heavy
  devPlusPackages = with pkgs; [
    android-studio
    emacs
    #ghidra
    #github-desktop
    imhex
    jetbrains.idea
    kdePackages.kompare
    kdePackages.kontrast
    #okteta
    unstable.typst
    # jdt-language-server # for zed
  ];

  gamePackages = with pkgs; [
    ckan
    moonlight-qt
    protontricks
    rpcs3 # uncached on hydra because unfree
    #unstable.eden
    #ryubing
  ];

  fontPackages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-emoji-blob-bin
    font-awesome
    iosevka-legible
    lexend
    twitter-color-emoji
  ];

  minecraftPackages = with pkgs; [
    (pkgs.cubiomes-viewer.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ../../overlays/cubiomes-viewer-patch/0001-fix-mapview-drag-on-linux-by-lowering-threshold-for-.patch
      ];
    }))
    unstable.mcaselector
    prismlauncher
  ];

  miscPackages = with pkgs; [
    libjxl # cjxl
    oxipng
    x265

    # unstable.ollama-rocm
  ];
in
{
  inherit
    desktopPackages
    kdeBaseDesktopPackages
    desktopPlusPackages
    kdeConfigPackages
    devPackages
    devPlusPackages
    gamePackages
    fontPackages
    minecraftPackages
    miscPackages
    ;
}
