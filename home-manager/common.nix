{
  config,
  dotfiles,
  lib,
  outputs,
  pkgs,
  ...
}:
let
  # lib.mkDefault value  # low-priority fallback
  # lib.mkForce value    # force this value
  # lib.mkBefore value   # prepend to a list
  # lib.mkAfter value    # append to a list
  #symlink = lib.mkDefault (name: config.lib.file.mkOutOfStoreSymlink /home/xiej/nix_config/home-manager/dotfiles + name);
  symlink = path: config.lib.file.mkOutOfStoreSymlink (dotfiles + path);
in
{
  imports = [
    # modules from this flake: modules/home-manager

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
  };

  programs.home-manager.enable = true;

  programs.vscode = {
    enable = true;
    #package = pkgs.unstable.vscode.fhs;
    package = lib.mkDefault pkgs.vscode.fhs;
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
      #{ name = "z"; src = pkgs.fishPlugins.z.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
    ];
  };
  programs.fzf.enableFishIntegration = true; # https://andrew-quinn.me/fzf/

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
      pkgs.tree-sitter
    ];
    sideloadInitLua = true;
  };
  # symlink configuration, use git subtree since submodules won't get copied
  home.file.".config/nvim".source = symlink /nvim_config/nvim;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
