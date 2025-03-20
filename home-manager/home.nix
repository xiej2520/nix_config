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
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "xiej";
    homeDirectory = "/home/xiej";
    
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";
  };

  # Add stuff for your user as you see fit:
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  home.packages = with pkgs; [
    discord
    ffmpeg-full
    fontforge-gtk
    gimp
    kdePackages.kate
    kdePackages.kclock
    
    iperf
    lutris
    moonlight-qt
    nh
    onedrivegui

    kdePackages.plasma-sdk
    kdePackages.qtwebengine

    protontricks
    shotcut
    spotify
    tree
    typst
    vlc
    wine
    wl-clipboard-rs
    zed-editor
    #  thunderbird
  ] ++ (with pkgs; [
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-emoji
    noto-fonts-emoji-blob-bin
    font-awesome
    lexend
    twitter-color-emoji

    (nerdfonts.override { fonts = [
      "iA-Writer"   # default, no ligatures
      
      # not released yet
      #"FragmentMono"    # wider, less serifs
      #"Maple"            # comic-ish, widths feel off
      #"Monocraft"        # classic
      "Monaspace" # Neon
    ];})
  ]) ++ (with pkgs; [
    cubiomes-viewer
    prismlauncher
  ]);

  # Enable home-manager
  programs.home-manager.enable = true;

  programs.bash.enable = true;

  programs.git = {
    enable = true;
    userEmail = "jackyxie2520@outlook.com";
    userName = "xiej2520";
  };
  home.file.".gitconfig".source = ./.gitconfig;
  home.file.".gitignore".source = ./.gitignore;

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


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
