# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cli = import ./cli { inherit pkgs; };
  desktop = import ./desktop { inherit pkgs; };

  symlink = name: config.lib.file.mkOutOfStoreSymlink name;
  # symlink = name: config.lib.file.mkOutOfStoreSymlink /home/xiej/Documents/nix_config/home-manager + name;
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    outputs.homeManagerModules.noctalia
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
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  home.packages =
    with pkgs;
    cli.cliPackages
    ++ desktop.desktopPackages
    ++ desktop.devPackages
    ++ desktop.fontPackages
    ++ desktop.minecraftPackages
    ++ (with pkgs; [

      kdePackages.ark
      kdePackages.dolphin-plugins
      # enabling this bricks kde on ubuntu? kdePackages.kdeplasma-addons
      kdePackages.plasma-nm
      #kdePackages.yakuake
      #klassy

      mako

      obs-studio

      xwayland-satellite
    ]);

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  programs.bash = {
    enable = true;
    historyControl = [ "ignoredups" ];
    initExtra = ''
      export PS1="''${PS1//\\u/\$SHLVL:\\u}"
      export PYTHONSTARTUP=~/.config/startup.py
    '';
  };

  programs.fish = {
    enable = true;
    plugins = [
      { name = "z"; src = pkgs.fishPlugins.z.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
    ];
  };

  programs.alacritty.enable = true;
  home.file.".config/alacritty/alacritty.toml".source = symlink ./alacritty.toml;

  home.file.".config/startup.py".source = symlink ./startup.py;

  #programs.git = {
  #  enable = true;
  #  userEmail = "jackyxie2520@outlook.com";
  #  userName = "xiej2520";
  #};
  home.file.".gitconfig".source = symlink ./.gitconfig;
  home.file.".gitignore".source = symlink ./.gitignore;

  programs.neovim.enable = true;
  # symlink configuration, use git subtree since submodules won't get copied
  home.file.".config/nvim".source = symlink ./nvim_config/nvim;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk25;
    #package = pkgs.jdk25.override {
    #  enableJavaFX = true;
    #};
  };

  programs.fuzzel.enable = true;

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "twitter-color-emoji" ];
        #monospace = [ "iA-Writer" ];
        monospace = [ "Iosevka" ];
        sansSerif = [ "Lexend Deca" ];
      };
    };
  };
}
