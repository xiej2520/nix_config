# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "xiej";
    homeDirectory = "/home/xiej";
    
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    discord

    gimp
    handbrake
    iperf

    kdePackages.filelight
    kdePackages.kclock
    kdePackages.kdeplasma-addons
    kdePackages.plasma-nm

    obs-studio
    onedrivegui
    qdirstat

    spotify
    transmission_4-qt
    vlc
    wl-clipboard-rs
  ] ++ (with pkgs; [
    avidemux
    ffmpeg-full
    mpv
    shotcut
    wine
    x265
  ]) ++ (with pkgs; [
    git
    github-desktop
    git-filter-repo
    gh

    jetbrains.idea-community-bin
    nh
    nixfmt-rfc-style

    ripgrep
    tree
    typst
    zed-editor
  ]) ++ (with pkgs; [
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-emoji-blob-bin
    font-awesome
    lexend
    twitter-color-emoji
  ]) ++ (with pkgs; [
    cubiomes-viewer
    mcaselector
    prismlauncher
  ]) ++ (with pkgs; [
    lutris
    moonlight-qt
    protontricks
  ]);

  #programs.bash = {
  #  enable = true;
  #  historyControl = [ "ignoredups" ];
  #};

  #programs.git = {
  #  enable = true;
  #  userEmail = "jackyxie2520@outlook.com";
  #  userName = "xiej2520";
  #};
  home.file.".gitconfig".source = config.lib.file.mkOutOfStoreSymlink ./.gitconfig;
  home.file.".gitignore".source = config.lib.file.mkOutOfStoreSymlink ./.gitignore;

  programs.neovim.enable = true;
  # symlink configuration, use git subtree since submodules won't get copied
  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink (builtins.toPath ./nvim-config/nvim);
  };
  
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
  
  programs.java = {
    enable = true;
    package = pkgs.jdk23.override {
      enableJavaFX = true;
    };
  };
  
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["twitter-color-emoji"];
        monospace = ["iA-Writer"];
        sansSerif = ["Lexend Deca"];
      };
    };
  };
}
