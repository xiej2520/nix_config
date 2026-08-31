# home-manager configuration file, replaces ~/.config/nixpkgs/home.nix
{
  config,
  pkgs,
  ...
}:
let
  cli = import ./cli { inherit pkgs; };
  desktop = import ./desktop { inherit pkgs; };

  dotfiles = /home/xiej/Documents/nix_config/home-manager/dotfiles;
  symlink = name: config.lib.file.mkOutOfStoreSymlink (dotfiles + name);
in
{
  imports = [
    # modules from this flake: modules/home-manager

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    ./common.nix
  ];

  _module.args = {
    inherit dotfiles;
  };

  home.stateVersion = "26.05";

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

  programs.java = {
    enable = true;
    package = pkgs.jdk25;
    #package = pkgs.jdk25.override {
    #  enableJavaFX = true;
    #};
  };

	xdg.configFile."niri/config.kdl".source = symlink /config.kdl;
  # gui-configured settings in ~/.local/state/noctalia/settings.toml
  xdg.configFile."noctalia/settings.toml".source = symlink /noctalia_settings.toml;

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
}
