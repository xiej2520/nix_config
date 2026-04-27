# home-manager configuration file, replaces ~/.config/nixpkgs/home.nix
{
  outputs,
  config,
  pkgs,
  ...
}:
let
  cli = import ./cli { inherit pkgs; };
  desktop = import ./desktop { inherit pkgs; };

  #symlink = name: config.lib.file.mkOutOfStoreSymlink name;
  symlink = name: config.lib.file.mkOutOfStoreSymlink /home/xiej/Documents/nix_config/home-manager/dotfiles + name;
in
{
  imports = [
    # modules from this flake: modules/home-manager

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./iosevka.nix
    ./noctalia.nix
  ];

  nixpkgs = {
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
    cli.cliPackages
    ++ desktop.desktopPackages
    ++ desktop.kdeBaseDesktopPackages
    ++ desktop.devPackages
    ++ desktop.fontPackages
    ++ desktop.minecraftPackages
    ++ (with pkgs; [
      kdePackages.dolphin-plugins
      # enabling this bricks kde on ubuntu? kdePackages.kdeplasma-addons
      kdePackages.plasma-nm
      #kdePackages.yakuake
      #klassy

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
  home.file.".config/alacritty/alacritty.toml".source = symlink /alacritty.toml;

  home.file.".config/startup.py".source = symlink /startup.py;

  #programs.git = {
  #  enable = true;
  #  userEmail = "jackyxie2520@outlook.com";
  #  userName = "xiej2520";
  #};
  home.file.".gitconfig".source = symlink /.gitconfig;
  home.file.".gitignore".source = symlink /.gitignore;

  programs.neovim = {
    enable = true;
    extraPackages = [
      pkgs.gcc # for tree-sitter
      pkgs.rust-analyzer # should really add LSPs in project-specific flake
    ];
  };
  # symlink configuration, use git subtree since submodules won't get copied
  home.file.".config/nvim".source = symlink /nvim_config/nvim;

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

	xdg.configFile."niri/config.kdl".source = symlink /config.kdl;
  xdg.configFile."noctalia/settings.json".source = symlink /noctalia_settings.json;

  programs.fuzzel.enable = true;

  services.udiskie = {
    enable = true;
    settings = {
      # workaround for
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        # replace with your favorite file manager
        file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      };
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "twitter-color-emoji" ];
        #monospace = [ "iA-Writer" ];
        monospace = [ "IosevkaLegible" ];
        sansSerif = [ "Lexend Deca" ];
      };
    };
  };
}
